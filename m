From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [Notice] multipath-tools changes upstream
Date: Tue, 15 Apr 2008 19:02:08 +0200
Message-ID: <1208278929.11770.62.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

Hi,

please take notice I updated the upstream git tree for the
multipath-tools project. This tree includes lots of code shuffling :

1) prioritizers as dlopen'ed shared libs (/lib/libmultipath/libprio*.so)
2) checkers as dlopen'ed shared libs (/lib/libmultipath/libcheck*.so)

Consequences :
The multipath tool is about to get shot for good
The klibc build is gone

Please review, and comment.

Regards,
cvaroqui
