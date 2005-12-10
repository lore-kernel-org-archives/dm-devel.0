From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [KJ] [PATCH] dm: uninitialize static variables
Date: Sat, 10 Dec 2005 18:35:59 +0300
Message-ID: <20051210153559.GB2003@mipter.zuzino.mipt.ru>
References: <20051205132800.34631bbf@lucky.kitzblitz>
	<50993.206.49.219.34.1133786860.squirrel@webmail.embedded.cl>
	<20051205190029.4b29e759@lucky.kitzblitz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============56483868724768149=="
Return-path: <kernel-janitors-bounces@lists.osdl.org>
In-Reply-To: <20051205190029.4b29e759@lucky.kitzblitz>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: Nicolas Kaiser <nikai@nikai.net>
Cc: "Carlos Manuel Duclos Vergara"carlos@embedded.cl, dm-devel@redhat.com, kernel-janitors@lists.osdl.org
List-Id: dm-devel.ids

--===============56483868724768149==
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 05, 2005 at 07:00:29PM +0100, Nicolas Kaiser wrote:
> * "Carlos Manuel Duclos Vergara" <carlos@embedded.cl>:
> > > uninitialize static variables initialized to 0, to make them go
> > > to .bss instead of .data.
> > >
> >
> > if you want that why not explicitely put them in .bss?
> > something like:
> >
> > > -static unsigned int major = 0;
> > > +static unsigned int major; /* = 0 */
> >
> > static unsigned int major = 0 __attribute__ ((section(".bss"));
>
> I personally like the idea of explicitly expressing this intention,
> but I didn't manage to achieve this together with initialization.

Not only you use gcc'ism, you also make code needlessly verbose.


--===============56483868724768149==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
https://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============56483868724768149==--
