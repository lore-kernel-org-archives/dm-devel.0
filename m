From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 02/14] libmultipath: check malloc return
 value in, print_foreign_topology
Date: Thu, 03 Sep 2020 19:29:10 +0200
Message-ID: <a8b50e520ec67accfedbec3ddb32493207a6234d.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<a89192b4-f330-6a18-e4d7-e18305b1e66a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a89192b4-f330-6a18-e4d7-e18305b1e66a@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, 2020-09-02 at 15:16 +0800, lixiaokeng wrote:
> We check the return value of malloc in print_foreign_topology.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  libmultipath/foreign.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
> index e8f61351..44f32d03 100644
> --- a/libmultipath/foreign.c
> +++ b/libmultipath/foreign.c
> @@ -545,6 +545,10 @@ void print_foreign_topology(int verbosity)
>  	char *buf = NULL, *tmp = NULL;
> 
>  	buf = malloc(buflen);
> +	if (!buf) {
> +		condlog (0, "malloc buf failed.");
> +		return;
> +	}

Just replace the malloc() by calloc() please, and remove the buf[0]
initialization. No need for an error message.

Martin


>  	buf[0] = '\0';
>  	while (buf != NULL) {
>  		char *c = buf;
> --
> 
