From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: update for shared path checker context
Date: Tue, 21 Nov 2006 01:02:55 +0100
Message-ID: <1164067375.25061.7.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1564@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-uin47HTF+dHHb8B82eeX"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1564@CORPUSMX40A.corp.emc.com>
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


--=-uin47HTF+dHHb8B82eeX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le vendredi 17 novembre 2006 =C3=A0 11:21 -0500, Edward Goggin a =C3=A9cr=
it :
> Christophe,
>=20
> I made the following changes.
>=20
> modified the path checker interface so that each path checker
> type could specify the size of their shared path context area
>=20
> discovery.c:get_state() now returns without setting path state
> if the path's mpp pointer is not set (IFF PP_DAEMON) else it
> becomes tricky to update the path checker's ptr to the shared
> context area after the path checker has been already initialized.
>=20
> structs.c:free_multipath() now frees shared context area if it was
> allocated.
>=20
Wouldn't a void** mpcontext in struct multipath instead of a void* keep
us from resorting to those ->size_scxt fonctions ?

- mpcontext allocation is deported insode the checker, so only the
checker needing the facility have to care.
- mpcontext freeing in free_multipath is ok, I guess

Something like the attached patch, for example.
(extreme hack to readsector0 to showcase the facility)

Regards,
cvaroqui


--=-uin47HTF+dHHb8B82eeX
Content-Disposition: attachment; filename=0002-mpcontext.diff
Content-Type: text/x-patch; name=0002-mpcontext.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/libcheckers/checkers.c b/libcheckers/checkers.c
index 53770a6..4f6928f 100644
--- a/libcheckers/checkers.c
+++ b/libcheckers/checkers.c
@@ -75,8 +75,9 @@ struct checker * checker_lookup (char * 
 	return NULL;
 }
 
-int checker_init (struct checker * c)
+int checker_init (struct checker * c, void ** mpctxt_addr)
 {
+	c->mpcontext = mpctxt_addr;
 	return c->init(c);
 }
 
diff --git a/libcheckers/checkers.h b/libcheckers/checkers.h
index 219dfaf..050644a 100644
--- a/libcheckers/checkers.h
+++ b/libcheckers/checkers.h
@@ -83,6 +83,8 @@ struct checker {
 	char name[CHECKER_NAME_LEN];
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
 	void * context;                      /* store for persistent data */
+	void ** mpcontext;                   /* store for persistent data
+						shared multipath-wide */
 	int (*check)(struct checker *);
 	int (*init)(struct checker *);       /* to allocate the context */
 	void (*free)(struct checker *);      /* to free the context */
@@ -90,7 +92,7 @@ struct checker {
 
 #define MSG(c, a) snprintf((c)->message, CHECKER_MSG_LEN, a);
 
-int checker_init (struct checker *);
+int checker_init (struct checker *, void **);
 void checker_put (struct checker *);
 void checker_reset (struct checker * c);
 void checker_set_fd (struct checker *, int);
diff --git a/libcheckers/readsector0.c b/libcheckers/readsector0.c
index dd18528..bd95ceb 100644
--- a/libcheckers/readsector0.c
+++ b/libcheckers/readsector0.c
@@ -26,6 +26,12 @@ struct readsector0_checker_context {
 
 int readsector0_init (struct checker * c)
 {
+	void * mpctxt = malloc(sizeof(int));
+	if (c->mpcontext)
+		*c->mpcontext = mpctxt;
+	int * toto = mpctxt;
+	*toto = 0;
+fprintf(stdout, "init: set count = %i\n", *toto);
 	return 0;
 }
 
@@ -100,6 +106,9 @@ readsector0 (struct checker * c)
 	int ret;
 
 	ret = sg_read(c->fd, &buf[0], &sbuf[0]);
+int * toto = *c->mpcontext;
+(*toto)++;
+fprintf(stdout, "count = %i\n", *toto);
 
 	switch (ret)
 	{
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6f2059a..a4a7997 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -611,12 +611,15 @@ get_state (struct path * pp)
 {
 	struct checker * c = &pp->checker;
 
+	if (!pp->mpp)
+		return 0;
+
 	if (!checker_selected(c)) {
 		select_checker(pp);
 		if (!checker_selected(c))
 			return 1;
 		checker_set_fd(c, pp->fd);
-		if (checker_init(c))
+		if (checker_init(c, &pp->mpp->mpcontext))
 			return 1;
 	}
 	pp->state = checker_check(c);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index db3f824..d36eaef 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -117,9 +117,10 @@ alloc_multipath (void)
 
 	mpp = (struct multipath *)MALLOC(sizeof(struct multipath));
 
-	if (mpp)
+	if (mpp) {
 		mpp->bestpg = 1;
-
+		mpp->mpcontext = NULL;
+	}
 	return mpp;
 }
 
@@ -180,6 +181,7 @@ #endif
 
 	free_pathvec(mpp->paths, free_paths);
 	free_pgvec(mpp->pg, free_paths);
+	FREE_PTR(mpp->mpcontext);
 	FREE(mpp);
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 7db7faa..77dd4af 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -154,6 +154,9 @@ struct multipath {
 	unsigned int stat_map_loads;
 	unsigned int stat_total_queueing_time;
 	unsigned int stat_queueing_timeouts;
+
+	/* checkers shared data */
+	void * mpcontext;
 };
 
 struct pathgroup {

--=-uin47HTF+dHHb8B82eeX
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-uin47HTF+dHHb8B82eeX--
