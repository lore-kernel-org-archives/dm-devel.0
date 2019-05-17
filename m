From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 2/7] mpathpersist: add option --batch-file
	(-f)
Date: Sat, 18 May 2019 00:56:58 +0200
Message-ID: <20190517225703.16295-3-mwilck@suse.com>
References: <20190517225703.16295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190517225703.16295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dbond@redhat.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Add the option --batch-file (-f) to mpathpersist. The option argument
is a text file that is parsed line-by-line. Every line of the file is
interpreted as an additional input line for mpathpersist. The initial
"mpathpersist" on each line is optional. The '#' character denotes
a comment. '#' is only recognized after whitespace. Empty lines,
or comment lines, are allowed.

If -f is given, other command line options are parsed as usual and
commands (if any) are run before running the batch file. Inside the
batch file, the option -f is forbidden, and -v is ignored. If a command
fails, the batch processing is not aborted. The return status of
mpathpersist is 0 if all commands succeeded, and the status of the
first failed command otherwise.
---
 mpathpersist/main.c | 195 +++++++++++++++++++++++++++++++++++---------
 mpathpersist/main.h |   1 +
 2 files changed, 159 insertions(+), 37 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 94e89c13..c1a6d3c8 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -15,6 +15,7 @@
 #include <pthread.h>
 #include <ctype.h>
 #include <string.h>
+#include <errno.h>
 
 static const char * pr_type_strs[] = {
 	"obsolete [0]",
@@ -59,7 +60,99 @@ void rcu_unregister_thread_memb(void) {}
 
 struct udev *udev;
 
-int main (int argc, char * argv[])
+static int verbose, loglevel, noisy;
+
+static int handle_args(int argc, char * argv[], int line);
+
+static int do_batch_file(const char *batch_fn)
+{
+	char command[] = "mpathpersist";
+	const int ARGV_CHUNK = 2;
+	const char delims[] = " \t\n";
+	size_t len = 0;
+	char *line = NULL;
+	ssize_t n;
+	int nline = 0;
+	int argl = ARGV_CHUNK;
+	FILE *fl;
+	char **argv = calloc(argl, sizeof(*argv));
+	int ret = MPATH_PR_SUCCESS;
+
+	if (argv == NULL)
+		return MPATH_PR_OTHER;
+
+	fl = fopen(batch_fn, "r");
+	if (fl == NULL) {
+		fprintf(stderr, "unable to open %s: %s\n",
+			batch_fn, strerror(errno));
+		free(argv);
+		return MPATH_PR_SYNTAX_ERROR;
+	} else {
+		if (verbose >= 2)
+			fprintf(stderr, "running batch file %s\n",
+				batch_fn);
+	}
+
+	while ((n = getline(&line, &len, fl)) != -1) {
+		char *_token, *token;
+		int argc = 0;
+		int rv;
+
+		nline++;
+		argv[argc++] = command;
+
+		if (line[n-1] == '\n')
+			line[n-1] = '\0';
+		if (verbose >= 3)
+			fprintf(stderr, "processing line %d: %s\n",
+				nline, line);
+
+		for (token = strtok_r(line, delims, &_token);
+		     token != NULL && *token != '#';
+		     token = strtok_r(NULL, delims, &_token)) {
+
+			if (argc >= argl) {
+				int argn = argl + ARGV_CHUNK;
+				char **tmp;
+
+				tmp = realloc(argv, argn * sizeof(*argv));
+				if (tmp == NULL)
+					break;
+				argv = tmp;
+				argl = argn;
+			}
+
+			if (argc == 1 && !strcmp(token, command))
+				continue;
+
+			argv[argc++] = token;
+		}
+
+		if (argc <= 1)
+			continue;
+
+		if (verbose >= 2) {
+			int i;
+
+			fprintf(stderr, "## file %s line %d:", batch_fn, nline);
+			for (i = 0; i < argc; i++)
+				fprintf(stderr, " %s", argv[i]);
+			fprintf(stderr, "\n");
+		}
+
+		optind = 0;
+		rv = handle_args(argc, argv, nline);
+		if (rv != MPATH_PR_SUCCESS)
+			ret = rv;
+	}
+
+	fclose(fl);
+	free(argv);
+	free(line);
+	return ret;
+}
+
+static int handle_args(int argc, char * argv[], int nline)
 {
 	int fd, c, res;
 	const char *device_name = NULL;
@@ -82,51 +175,35 @@ int main (int argc, char * argv[])
 	int prin = 1;
 	int prin_sa = -1;
 	int prout_sa = -1;
-	int verbose = 0;
-	int loglevel = 0;
-	int noisy = 0;
 	int num_transport =0;
+	char *batch_fn = NULL;
 	void *resp = NULL;
 	struct transportid * tmp;
-	struct config *conf;
-
-	if (optind == argc)
-	{
-
-		fprintf (stderr, "No parameter used\n");
-		usage ();
-		exit (1);
-	}
-
-	if (getuid () != 0)
-	{
-		fprintf (stderr, "need to be root\n");
-		exit (1);
-	}
-
-	udev = udev_new();
-	conf = mpath_lib_init();
-	if(!conf) {
-		udev_unref(udev);
-		exit(1);
-	}
+	struct config *conf = multipath_conf;
 
 	memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct transportid));
-	multipath_conf = conf;
 
 	while (1)
 	{
 		int option_index = 0;
 
-		c = getopt_long (argc, argv, "v:Cd:hHioYZK:S:PAT:skrGILcRX:l:",
+		c = getopt_long (argc, argv, "v:Cd:hHioYZK:S:PAT:skrGILcRX:l:f:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
 
 		switch (c)
 		{
+			case 'f':
+				if (nline != 0) {
+					fprintf(stderr, "-f option not allowed in batch file\n");
+					ret = MPATH_PR_SYNTAX_ERROR;
+					goto out;
+				}
+				batch_fn = strdup(optarg);
+				break;
 			case 'v':
-				if (1 != sscanf (optarg, "%d", &loglevel))
+				if (nline == 0 && 1 != sscanf (optarg, "%d", &loglevel))
 				{
 					fprintf (stderr, "bad argument to '--verbose'\n");
 					return MPATH_PR_SYNTAX_ERROR;
@@ -287,11 +364,13 @@ int main (int argc, char * argv[])
 		}
 	}
 
-	/* set verbosity */
-	noisy = (loglevel >= 3) ? 1 : hex;
-	verbose	= (loglevel >= 3)? 3: loglevel;
+	if (nline == 0) {
+		/* set verbosity */
+		noisy = (loglevel >= 3) ? 1 : hex;
+		verbose	= (loglevel >= 3)? 3: loglevel;
+	}
 
-	if ((prout_flag + prin_flag) == 0)
+	if ((prout_flag + prin_flag) == 0 && batch_fn == NULL)
 	{
 		fprintf (stderr, "choose either '--in' or '--out' \n");
 		ret = MPATH_PR_SYNTAX_ERROR;
@@ -341,7 +420,8 @@ int main (int argc, char * argv[])
 	}
 	else
 	{
-		ret = MPATH_PR_SYNTAX_ERROR;
+		if (batch_fn == NULL)
+			ret = MPATH_PR_SYNTAX_ERROR;
 		goto out;
 	}
 
@@ -487,10 +567,51 @@ int main (int argc, char * argv[])
 	}
 
 out :
-	if (ret == MPATH_PR_SYNTAX_ERROR)
-		usage();
-	mpath_lib_exit(conf);
+	if (ret == MPATH_PR_SYNTAX_ERROR) {
+		if (nline == 0)
+			usage();
+		else
+			fprintf(stderr, "syntax error on line %d in batch file\n",
+				nline);
+	} else if (batch_fn != NULL) {
+		int rv = do_batch_file(batch_fn);
+
+		free(batch_fn);
+		ret = ret == 0 ? rv : ret;
+	}
+	return (ret >= 0) ? ret : MPATH_PR_OTHER;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (optind == argc)
+	{
+
+		fprintf (stderr, "No parameter used\n");
+		usage ();
+		exit (1);
+	}
+
+	if (getuid () != 0)
+	{
+		fprintf (stderr, "need to be root\n");
+		exit (1);
+	}
+
+	udev = udev_new();
+	multipath_conf = mpath_lib_init();
+	if(!multipath_conf) {
+		udev_unref(udev);
+		exit(1);
+	}
+
+	ret = handle_args(argc, argv, 0);
+
+	mpath_lib_exit(multipath_conf);
 	udev_unref(udev);
+
 	return (ret >= 0) ? ret : MPATH_PR_OTHER;
 }
 
diff --git a/mpathpersist/main.h b/mpathpersist/main.h
index beb8a21b..c5f53f52 100644
--- a/mpathpersist/main.h
+++ b/mpathpersist/main.h
@@ -23,6 +23,7 @@ static struct option long_options[] = {
 	{"reserve", 0, NULL, 'R'},
 	{"transport-id", 1, NULL, 'X'},
 	{"alloc-length", 1, NULL, 'l'},
+	{"batch-file", 1, NULL, 'f' },
 	{NULL, 0, NULL, 0}
 };
 
-- 
2.21.0
