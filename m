From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [Bug 158603][PATCH] New: local variable used before set
Date: Tue, 24 May 2005 11:24:33 +0200
Message-ID: <20050524092433.GA1933@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Quite broken logic, true ...

===== cut here =====
--- 434d2afe39c8a54a5788f312dd2a6653f7c2560a/libmultipath/pgpolicies.c  (mode:100644)
+++ uncommitted/libmultipath/pgpolicies.c  (mode:100644)
@@ -243,7 +243,7 @@
 {
        struct pathgroup * pgp;

-       if (VECTOR_SIZE(pgp->paths) < 0)
+       if (VECTOR_SIZE(mp->paths) < 0)
                return 0;

        if (!mp->pg)
=====
Regards,
cvaroqui
