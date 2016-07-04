From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH V3 1/3] multipath-tools: Increase
 MAX_REPLY_LEN.
Date: Mon, 4 Jul 2016 17:11:46 +0800
Message-ID: <20160704091146.GA3081@redhat.com>
References: <1455264623-16199-2-git-send-email-fge@redhat.com>
	<20160701124656.169890-1-fge@redhat.com>
	<20160701124656.169890-2-fge@redhat.com> <5776825D.8050202@suse.de>
	<20160702002537.GA1361@redhat.com> <5779FC9F.6010209@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2932878704034586347=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5779FC9F.6010209@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============2932878704034586347==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2016 at 08:05:19AM +0200, Hannes Reinecke wrote:
> On 07/02/2016 02:25 AM, Gris Ge wrote:
> > On Fri, Jul 01, 2016 at 04:46:53PM +0200, Hannes Reinecke wrote:
> >>> -#define MAX_REPLY_LEN		65536
> >>> +#define MAX_REPLY_LEN		10485760
> >>> +/* ^ 10 MiB, enough for 'show maps json' command with 10k paths which
> >>> + *   requires about 8 MiB */
> >>> =20
> >>> =20
> >> Huh.
> >> Can't say I like it. The limit is pretty much self-imposed, so I'd
> >> rather bite the bullet and make it size-independent.
> >>
> >> Cheers,
> >>
> >> Hannes
> >> --=20
> >> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> >=20
> > Hi Hannes Reinecke,
> >=20
> > How about limit the input command string size and let multipathd
> > output size-independent?
> >=20
> Hmm?
> We already know the size of the input (we're getting it from the
> commandline, after all). So there's no need to arbitrary limit
Not exactly, malicious IPC client application using their own socket
client implementation could send something like:
    999999999999999fake command
which will lead multipathd daemon to allocate a big chunk of memory.

Even with legal IPC client library libmpathcmd, IPC client could send
a really string to daemon.

I reworked this patch to prevent this.

Meanwhile since we don't have IPC socket user ID check, above
malicious command does not require root privilege(will fix in next
week).
> anything here; we know exactly how much memory we need to allocate.
> It's just for the _output_ where we need to be careful, as we need
> to ensure that we don't allocate insane amount of memory in the
> daemon nor in the client.
On the contrary, if multipathd daemon output a insane mount of memory,
it should be a bug of multipathd daemon, rather than libmpathcmd.

Data from multipathd to IPC client[1] should be trusted and unlimited,
while data from IPC client to multipathd should be limited to
small size(let's say 255 is enough).
> So for the output we should look at implementing some sort of
> chunked response; maybe having a 4k transmit buffer, and adding a
> status bit in the CLI response instructing the client to keep on
> reading.  Or something like that.

>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		   Teamlead Storage & Networking

[1]: 'multipathd -k' is IPC client also.

--=20
Gris Ge

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXeihSAAoJEGzN5Y/kHij/cc8P/3c+RuKVpPBjgjPyUkoY06ak
HxhO3cL2DpORvz821UtmEG85ybrqJpu6P3tIYnslXMaAXRo1hkqaFfFGI2cvvsLl
vAqPzybr7HNR/PWJrPpCglGiOizrgaCjVm8D00lqprmgPU3SUpxUNR0iArjU+Q+J
qJt+AbREwXzF3WujlgYSdN7OZLHeQ1JxxWgXMi+CsKDjiKLj5n8EiGYND35X3Vyh
6fvdB8+Xu5k720eFvpjbBmoPauffskqgGCxeq6VbaI/dWtTRgwAv192ebLY1+jx3
sHMIVWvknVSewvGiYx4YzGRz4Xe8h5sipnI93BweVtRzWHZM3wOdzNp39VHc847V
xDqszFUTmsVQaCZkSFvXadSRIHwJXGz+7LyiFOIOiB3ct7uDky++7eq5FEaAV8XU
GDCqtP05E7As0JrzBjJb+/RkvbPhAbxDJGL83FcVqkrx8vF/1ms9pY1T9AEaiXwm
9rekxZxazglH3rRFhs5omrLJYaMMtqB4U3Bv3zGpMe8yjyuBzTm5m36JV48802M1
xGZziGMNto/MZhppIBvZjKKe+6GXeLgaNGu56cyhHyQk+F5wkPnXejDSGcNyEU5e
gEFzqlGCwtDaXPoTQabcoLXjhhGlYb3o9Y5iOVEf8N53Fui/zpWXIb9WxT707OrS
g3AG6d2v7a/K+x3QJY6q
=rHfu
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--


--===============2932878704034586347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2932878704034586347==--
