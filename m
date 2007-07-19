From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tool udev rules require missing dmsetup
	features
Date: Thu, 19 Jul 2007 08:16:22 +0200
Message-ID: <20070719061622.GB21899@pentland.suse.de>
References: <469EB881.6070207@csupomona.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <469EB881.6070207@csupomona.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2007 at 06:04:01PM -0700, Brian De Wolf wrote:
> Hello,
>=20
> Recently I've been using the latest git versions of multipath-tools and=
 I've
> noticed that the udev rules that are included, specifically those for k=
partx,
> refer to environment variables such as DM_TABLE_STATE, DM_PART, DM_UUID=
, etc.
> However, the kpartx.rules file contains nothing that would bring those
> environment variables into the environment.  After some googling, I fou=
nd
> http://ftp.frugalware.org/pub/frugalware/frugalware-current/source/lib/=
device-mapper/
> which has a patch that adds a command to dmsetup called 'export'.  I've=
 found
> various udev scripts that use this command to pull the environment vari=
ables I
> listed before for use in udev rules and the multipath-tools kpartx.rule=
s file
> itself works perfectly when the correct 'dmsetup export' command is imp=
orted.
>=20
Errm. Oops.

Well, I'm to blame here. When creating the rules I totally forgot that we=
've hacked
dmsetup to provide an 'export' switch.

> What really puzzles me is that this patch was very difficult to find, b=
ut is
> essential to the 'official' multipath-tools udev rules.  Is there somet=
hing that
> I'm missing that makes this all make sense?
>=20
As already said, it totally makes sense when you hack up dmsetup and then=
 forget
about the patch. Sorry about this.

Alasdair, care to incorporate it?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=EF=BF=BDrnberg
GF: Markus Rex, HRB 16746 (AG N=EF=BF=BDrnberg)

--Dxnq1zWXvFF0Q93v
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="device-mapper-dmsetup-export.patch"

diff --git a/dmsetup/dmsetup.c b/dmsetup/dmsetup.c
index 25f14a6..b693008 100644
--- a/dmsetup/dmsetup.c
+++ b/dmsetup/dmsetup.c
@@ -995,6 +995,94 @@ static int _status(int argc, char **argv
 	return r;
 }
 
+static int _export(int argc, char **argv, void *data)
+{
+	int r = 0;
+	struct dm_task *dmt = NULL;
+	void *next = NULL;
+	uint64_t start, length;
+	char *target_type = NULL;
+	char *params;
+	struct dm_names *names = (struct dm_names *) data;
+	const char *name = NULL;
+	const char *uuid = NULL;
+	struct dm_info info;
+
+	if (data)
+		name = names->name;
+	else if (argc == 2)
+		name = argv[1];
+
+	if (!(dmt = dm_task_create(DM_DEVICE_STATUS)))
+		goto out;
+
+	if (!_set_task_device(dmt, name, 0))
+		goto out;
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!dm_task_get_info(dmt, &info) || !info.exists)
+		goto out;
+
+	if (!name)
+		name = dm_task_get_name(dmt);
+
+	uuid = dm_task_get_uuid(dmt);
+	printf("DM_NAME=%s\n", name);
+
+	if ((uuid = dm_task_get_uuid(dmt)) && *uuid)
+		printf("DM_UUID=%s\n", uuid);
+
+	if (!info.exists) {
+		printf("DM_STATE=NOTPRESENT\n");
+		goto out;
+	}
+
+	printf("DM_STATE=%s\n",
+	       info.suspended ? "SUSPENDED" :
+	       (info.read_only ? " READONLY" : "ACTIVE"));
+
+	if (!info.live_table && !info.inactive_table)
+		printf("DM_TABLE_STATE=NONE\n");
+	else
+		printf("DM_TABLE_STATE=%s%s%s\n",
+		       info.live_table ? "LIVE" : "",
+		       info.live_table && info.inactive_table ? "/" : "",
+		       info.inactive_table ? "INACTIVE" : "");
+
+	if (info.open_count != -1)
+		printf("DM_OPENCOUNT=%d\n", info.open_count);
+
+	printf("DM_LAST_EVENT_NR=%" PRIu32 "\n", info.event_nr);
+
+	printf("DM_MAJOR=%d\n", info.major);
+	printf("DM_MINOR=%d\n", info.minor);
+
+	if (info.target_count != -1)
+		printf("DM_TARGET_COUNT=%d\n", info.target_count);
+
+	/* export all table types */
+	next = dm_get_next_target(dmt, next, &start, &length,
+				  &target_type, &params);
+	if (target_type) {
+		printf("DM_TARGET_TYPES=%s", target_type);
+		while (next) {
+			next = dm_get_next_target(dmt, next, &start, &length,
+						  &target_type, &params);
+			if (target_type)
+				printf(",%s", target_type);
+		}
+		printf("\n");
+	}
+
+	r = 1;
+      out:
+	if (dmt)
+		dm_task_destroy(dmt);
+	return r;
+}
+
 /* Show target names and their version numbers */
 static int _targets(int argc __attribute((unused)), char **argv __attribute((unused)), void *data __attribute((unused)))
 {
@@ -1699,6 +1787,7 @@ static struct command _commands[] = {
 	{"info", "[<device>]", 0, 1, _info},
 	{"deps", "[<device>]", 0, 1, _deps},
 	{"status", "[<device>] [--target <target_type>]", 0, 1, _status},
+	{"export", "[<device>]", 0, 1, _export},
 	{"table", "[<device>] [--target <target_type>] [--showkeys]", 0, 1, _status},
 	{"wait", "<device> [<event_nr>]", 0, 2, _wait},
 	{"mknodes", "[<device>]", 0, 1, _mknodes},
diff --git a/man/dmsetup.8 b/man/dmsetup.8
index 5b2ed9f..c4524aa 100644
--- a/man/dmsetup.8
+++ b/man/dmsetup.8
@@ -39,13 +39,16 @@ dmsetup \- low level logical volume mana
 .B dmsetup ls
 .I [--target target_type] [--exec command] [--tree [-o options]]
 .br
-.B dmsetup info 
+.B dmsetup info
 .I [device_name]
 .br
 .B dmsetup info -c|-C|--columns
 .I [--noheadings] [--separator separator] [-o fields] [-O|--sort sort_fields]
 .I [device_name]
 .br
+.B dmsetup export
+.I [device_name]
+.br
 .B dmsetup deps
 .I [device_name]
 .br
@@ -138,6 +141,10 @@ device_name in subsequent dmsetup comman
 If successful a device will appear as
 /dev/device-mapper/<device-name>.  
 See below for information on the table format.
+.IP \fBexport
+.I [device_name]
+.br
+Outputs information in key/value format to be imported by other programs.
 .IP \fBdeps
 .I [device_name]
 .br

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Dxnq1zWXvFF0Q93v--
