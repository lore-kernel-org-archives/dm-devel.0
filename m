From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] [PATCH] add serial keyword to the weightedpath
	prioritizer
Date: Mon, 1 Aug 2016 15:18:16 +0200
Message-ID: <d14bb6d9-70f2-0daf-7fd7-91e76cc6a1d7@suse.de>
References: <CABr-Gndh4LLgd=T00GdtwNVrFgL7Te91BwjZ0Dh4uYyDi3c9bA@mail.gmail.com>
	<d9c1d17d-83c2-3e68-166c-78f44c5dd21d@suse.de>
	<CABr-GnfBwx6Fb1D7-2L0RiUP_ujOP8ZpH2WM0kyQR8f42424Pg@mail.gmail.com>
	<135275ad-ad45-7be3-d23c-6dc0dfb9d833@suse.de>
	<CABr-Gnd6zGeHgo5ka1LjQ5xB2WtZVCW_-=fH8UYZR_qppfog8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gnd6zGeHgo5ka1LjQ5xB2WtZVCW_-=fH8UYZR_qppfog8Q@mail.gmail.com>
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

On 08/01/2016 02:25 PM, Christophe Varoqui wrote:
> Or we could honor arythmetic expressions like "5*alua+weightedpath",
> giving users more control about preferences (and more opportunities to
> step on their toes, sure).
>
Ugh. No.
You still would need to know which values the 'alua' (or any =

prioritizer) will be returning.
ATM there is no guarantee nor even advise which values a prioritizer =

should return. Which in itself is a good idea IMHO.

> Another idea, less invasive if possible, but less versatile :
>
> - Merge the alua prioritizer into the weightedpath prioritizer, given
> the optimized/non-optimized and other ALUA states are available in the
> path struct and have their snprint_path_* function and %wildcard.
>
Hmm. I still prefer the 'stacked prioritizer' approach, what with it =

being far more flexible.

> - Then weightedpath prio_args can be extended to support additive
> priorities, like "alua <optimized state>:<... state> 10 serial foo 20"
>
Which again would require us to define the possible return values from =

the alua (or any other handler).

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
