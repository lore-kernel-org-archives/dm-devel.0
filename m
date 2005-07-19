From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [multipathd] kill clone() ?
Date: Tue, 19 Jul 2005 15:36:06 +0200
Message-ID: <20050719133606.GA19691@averon.dyndns.org>
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

Ed, Alasdair, et al,

this is your last chance to convince me not to kill clone()/private namespace/ramfs logic in multipathd.
Because :

1) Martin spoted some rough edges with it and pthread cancelations.
2) It was introduced at a time when path reinstate was done by /sbin/multipath, which is not the case anymore.
3) It simplifies the design a fair bit and removes quite a lot of code.

I verified the path reinstate codepath, and it does only 1 dmt allocation ... no callbacks anymore.
So I guess it is safe to kill, be would like to raise the point one last time.

Regards,
cvaroqui
