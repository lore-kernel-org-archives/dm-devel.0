From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 10/14] util/tests: use assert_non_null to
 ensure malloc, returns non-null pointer
Date: Fri, 4 Sep 2020 16:31:29 -0500
Message-ID: <20200904213129.GF11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<a712b9bd-fa57-b723-129d-c6d8a61c8e84@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a712b9bd-fa57-b723-129d-c6d8a61c8e84@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: lixiaokeng <lixiaokeng@huawei.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, Sep 02, 2020 at 03:22:37PM +0800, lixiaokeng wrote:
> In tests/util.c, we should use assert_non_null to ensure
> malloc() returns non-null pointer in both test_strlcpy_5
> and test_strlcpy_6 func.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  tests/util.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/util.c b/tests/util.c
> index 16774dff..455eeee5 100644
> --- a/tests/util.c
> +++ b/tests/util.c
> @@ -523,6 +523,7 @@ static void test_strlcpy_5(void **state)
>  	const int sz = sizeof(src_str);
> 
>  	tst = malloc(sz);
> +	assert_non_null(tst);
>  	memset(tst, 'f', sizeof(src_str));
> 
>  	rc = strlcpy(tst, src_str, sz);
> @@ -540,6 +541,7 @@ static void test_strlcpy_6(void **state)
>  	const int sz = sizeof(src_str);
> 
>  	tst = malloc(sz + 2);
> +	assert_non_null(tst);
>  	memset(tst, 'f', sz + 2);
> 
>  	rc = strlcpy(tst, src_str, sz + 2);
> -- 
