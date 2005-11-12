From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] multipath-tools: multipathd makes offline
	devices active
Date: Sat, 12 Nov 2005 01:12:10 +0100
Message-ID: <1131754330.7463.104.camel@zezette>
References: <20051111.184322.71083111.k-ueda@ct.jp.nec.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051111.184322.71083111.k-ueda@ct.jp.nec.com>
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

On ven, 2005-11-11 at 18:43 -0500, Kiyoshi Ueda wrote:
> Hi Christophe,
> 
> multipathd(8) continues calling reinstate_path() in checkerloop(),
> if multipathd(8) is started on the system which has multipath maps
> including offline devices.
> The reason is pp->checkfn() returns -1 for offline devices and
> pp->state of these paths are 1.
> (I'm using "echo offline > /sys/block/sd?/device/state" for the testing.)
> 
> As a result, multipathd(8) makes offline devices active state.
> And this behavior also affects the no_path_retry feature, since 
> struct multipath.nr_active is incremented in reinstate_path().
> 
> The following patch fixes this problem.
> If the return value from pp->checkfn is -1, the path isn't available.
> So I think that we can ignore it.
> 
Looks correct, indeed.
Thanks, applied.

Regards,
cvaroqui
