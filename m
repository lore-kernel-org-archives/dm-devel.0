From: Hannes Reinecke <hare@suse.de>
Subject: Re: sg_persist triggers block kernel event ???
Date: Sun, 04 May 2014 18:54:55 +0200
Message-ID: <536670DF.2040605@suse.de>
References: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
	<CABr-GneD2JwJ5YHx9n5C42zeiivF5gg0hcg_mab1EuwucfOp0Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GneD2JwJ5YHx9n5C42zeiivF5gg0hcg_mab1EuwucfOp0Q@mail.gmail.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/04/2014 01:34 AM, Christophe Varoqui wrote:
> It seems sg_persist is doing an "open rw =3D> close" for --in commands,
> causing a kernel change-event.
Yep.

Look for 'watch' in the udev rules, that's precisely what it's doing.

(Bloody annoying if you ask me. Generally I recommend to remove that =

thing from the rules).

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
