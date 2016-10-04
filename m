From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 00/15] Fifteen multipath-tools patches
Date: Tue, 4 Oct 2016 10:36:23 -0700
Message-ID: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Christophe,

As promised I am sending you the multipath-tools patches from my local 
repository. The names of these patches are:

0001-libmultipath-prioritizers-ontap-Remove-an-unused-inc.patch
0002-libmultipath-memory-Move-an-include-directive.patch
0003-libmultipath-checkers-tur-Declare-local-functions-st.patch
0004-libmultipath-checkers-rbd-Declare-local-functions-st.patch
0005-multipathd-libmultipathd-Make-delays-independent-of-.patch
0006-multipathd-Suppress-uninteresting-data-race-reports.patch
0007-multipathd-Fix-a-data-race.patch
0008-libmultipath-checkers-tur-Introduce-strlcpy.patch
0009-libmultipath-checkers-tur-Terminate-a-statement-with.patch
0010-libmultipath-checkers-tur-Move-pthread_attr_destroy-.patch
0011-libmultipath-checkers-tur-Protect-tur_checker_contex.patch
0012-libmultipath-checkers-tur-Serialize-tur_checker_cont.patch
0013-libmultipath-checkers-tur-Fix-races-on-tur_checker_c.patch
0014-libmultipath-Micro-optimize-snprint_size.patch
0015-Makefile.inc-Enable-Wextra-and-Wformat-nonliteral.patch

Thanks,

Bart.
