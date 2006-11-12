From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: patch to CLARiiON path checker to handle inactive
	snapshhots
Date: Mon, 13 Nov 2006 00:38:16 +0100
Message-ID: <1163374696.10466.73.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1536@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-hRgxIbfHBwL8Zdsz2soD"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1536@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-hRgxIbfHBwL8Zdsz2soD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le vendredi 10 novembre 2006 =C3=A0 18:02 -0500, Edward Goggin a =C3=A9cr=
it :
...

Ok, I aknowledge this approach is far more complex than your 1st
attempt.

If I read correctly the two candidate patches, the clariion checker need
to share information with the other path chechers attached to the same
multipath to decide for a state to return.

If so, let's pretend another checker might one day stress the same
need :)

What do you think of a facility like the following (completely untested
and surely semi-bogus) patch sketches ? Would it make your patch as
straight as your first attempt ?

It seems to take care of our griefs with "container_of" and the
clariion-centric additions to "struct multipath".

Anyway, I'm sorry for keeping you walking in circles there.
Regards,
cvaroqui





--=-hRgxIbfHBwL8Zdsz2soD
Content-Disposition: attachment; filename=multipath-wide-checher-context.patch
Content-Type: text/x-patch; name=multipath-wide-checher-context.patch;
	charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/libcheckers/checkers.c b/libcheckers/checkers.c
index 53770a6..ee4d7fb 100644
--- a/libcheckers/checkers.c
+++ b/libcheckers/checkers.c
@@ -75,8 +75,9 @@ struct checker * checker_lookup (char * 
 	return NULL;
 }
 
-int checker_init (struct checker * c)
+int checker_init (struct checker * c, void * mpctxt)
 {
+	c->mpcontext = mpctxt;
 	return c->init(c);
 }
 
diff --git a/libcheckers/checkers.h b/libcheckers/checkers.h
index 15bac1a..7b49b7a 100644
--- a/libcheckers/checkers.h
+++ b/libcheckers/checkers.h
@@ -46,6 +46,8 @@ struct checker {
 	char name[CHECKER_NAME_LEN];
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
 	void * context;                      /* store for persistent data */
+	void * mpcontext;                    /* store for persistent data */
+                                             /* shared multipath-wide */
 	int (*check)(struct checker *);
 	int (*init)(struct checker *);       /* to allocate the context */
 	void (*free)(struct checker *);      /* to free the context */
@@ -53,7 +55,7 @@ struct checker {
 
 #define MSG(c, a) snprintf((c)->message, CHECKER_MSG_LEN, a);
 
-int checker_init (struct checker *);
+int checker_init (struct checker *, void *);
 void checker_put (struct checker *);
 void checker_reset (struct checker * c);
 void checker_set_fd (struct checker *, int);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 69c9bc3..1893851 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -610,13 +610,16 @@ static int
 get_state (struct path * pp)
 {
 	struct checker * c = &pp->checker;
+	void * mpctxt = NULL;
 
 	if (!checker_selected(c)) {
 		select_checker(pp);
 		if (!checker_selected(c))
 			return 1;
 		checker_set_fd(c, pp->fd);
-		if (checker_init(c))
+		if (pp->mpp)
+			mpctxt = pp->mpp->mpcontext;
+		if (checker_init(c, mpctxt))
 			return 1;
 	}
 	pp->state = checker_check(c);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index faa2b8f..45dbf85 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -151,6 +151,9 @@ struct multipath {
 	unsigned int stat_map_loads;
 	unsigned int stat_total_queueing_time;
 	unsigned int stat_queueing_timeouts;
+
+	/* checkers shared data */
+	void * mpcontext;
 };
 
 struct pathgroup {

--=-hRgxIbfHBwL8Zdsz2soD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-hRgxIbfHBwL8Zdsz2soD--
