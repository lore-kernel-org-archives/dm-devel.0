From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [KJ] [PATCH] dm: uninitialize static variables
Date: Sat, 10 Dec 2005 18:31:29 +0300
Message-ID: <20051210153129.GA2003@mipter.zuzino.mipt.ru>
References: <20051205132800.34631bbf@lucky.kitzblitz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============65532623562011949=="
Return-path: <kernel-janitors-bounces@lists.osdl.org>
In-Reply-To: <20051205132800.34631bbf@lucky.kitzblitz>
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
Cc: kernel-janitors@lists.osdl.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============65532623562011949==
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 05, 2005 at 01:28:00PM +0100, Nicolas Kaiser wrote:
> uninitialize static variables initialized to 0, to make them go
> to .bss instead of .data.

>  dm.c     |    4 ++--
>  kcopyd.c |    2 +-

diffstat -p1 ;-)

> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -20,8 +20,8 @@
>
>  static const char *_name = DM_NAME;
>
> -static unsigned int major = 0;
> -static unsigned int _major = 0;
> +static unsigned int major; /* = 0 */
> +static unsigned int _major; /* = 0 */

Drop the comments. major goes into .bss. .bss is initialized to 0.

> --- a/drivers/md/kcopyd.c
> +++ b/drivers/md/kcopyd.c

> -static int kcopyd_clients = 0;
> +static int kcopyd_clients; /* = 0 */


--===============65532623562011949==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
https://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============65532623562011949==--
