From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath: nr_active fix
Date: Sat, 18 Feb 2006 01:21:49 +0100
Message-ID: <1140222110.21077.27.camel@zezette>
References: <20060217004316.GC15044@ether.msp.redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060217004316.GC15044@ether.msp.redhat.com>
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

On jeu, 2006-02-16 at 18:43 -0600, Benjamin Marzinski wrote:
> There is some weirdness in the nr_active handling in multipathd, For instance,
> whenever you change state to a PATH_DOWN or PATH_SHAKY state, you decrement
> the number of active paths, even if you change from PATH_DOWN to PATH_SHAKY.
> 
> The attached patch attempts to fix the problem.  It slightly changes how some
> of the states are handled.
> 
Applied, though this one shows the code in this area needs more love :
it is too hard to read to be honest.

Anyway, you sure are right to account the ghost paths in nr_active.

BTW, I realize I forgot to credit you (Ben) in the git log. Sorry about
that.

Regards,
cvaroqui
