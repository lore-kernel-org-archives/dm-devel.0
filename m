From: "D. North" <rold5@tditx.com>
Subject: Re: HSG80, DM, multipath issues
Date: Mon, 10 Apr 2006 17:16:41 -0500
Message-ID: <20060410221641.GA7563@tditx.com>
References: <20060410174210.GA3798@tditx.com> <443AA3DF.3080404@free.fr>
	<20060410204822.GA6573@tditx.com> <443ACB3E.6060106@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <443ACB3E.6060106@free.fr>
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

Thus spake Christophe Varoqui (christophe.varoqui@free.fr):

> What strikes me in this map "0 443027195 multipath 0 0 2 1 round-robin 1 
> 1 8:0 1000 round-robin 1 1 8:16 1000" is the lack of <#selector args>.
> 
> ... but I don't reproduce here : "0 71122560 multipath 1 
> queue_if_no_path 0 2 1 round-robin 0 1 1 8:32 100 round-robin 0 1 1 8:80 
> 100"

Ok -- Thanks! .... That put me on the right track.

During my earlier testing, I tried several variations on the contents
of multipath.conf. The last one I'd tried had been a recommendation I read
setting path_selector to "round-robin" .... I set it to "round-robin 0" which
I had read in another recommendation, and now things are acting quite
reasonable. I think that now it is mostly a matter of getting my initrd
right and it'll be working.

Thanks!
-- 
D. North
