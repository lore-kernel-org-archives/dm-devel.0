From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/8] test-kpartx: add test for invocation on
	image file
Date: Fri, 12 Oct 2018 16:45:06 -0500
Message-ID: <20181012214506.GD29125@octiron.msp.redhat.com>
References: <20181010200506.15796-1-mwilck@suse.com>
	<20181010200506.15796-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181010200506.15796-2-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Stef Walter <stefw@redhat.com>, dm-devel@redhat.com, Yuval Turgeman <yturgema@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 10, 2018 at 10:04:59PM +0200, Martin Wilck wrote:
> Add a test for kpartx invocation on an image file that is not
> yet part of a loop device, passing a relative path to kpartx:
> 
>         # kpartx -av disk.img
>         ...
>         # kpartx -d disk.img
> 
> The recent patches 95c4189b "kpartx: Use absolute paths to create mappings"
> and c1adcc5b "kpartx: Use absolute paths to create mappings" both
> independently fixed this behavior, which had been broken previously by
> 9bdfa3eb "kpartx: use absolute path for regular files".
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Cc: Stef Walter <stefw@redhat.com>
> Cc: Yuval Turgeman <yturgema@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  kpartx/test-kpartx | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/kpartx/test-kpartx b/kpartx/test-kpartx
> index d2001dce..d3c9aef5 100755
> --- a/kpartx/test-kpartx
> +++ b/kpartx/test-kpartx
> @@ -87,6 +87,7 @@ step preparation
>  FILE1=kpartx1
>  FILE2=kpartx2
>  FILE3=kpartx3
> +FILE4=kpartx4
>  SIZE=$((1024*1024*1024))  # use bytes as units here
>  SECTSIZ=512
>  OFFS=32                # offset of linear mapping into dev, sectors
> @@ -108,6 +109,7 @@ step "create loop devices"
>  truncate -s $SIZE $FILE1
>  truncate -s $SIZE $FILE2
>  truncate -s $SIZE $FILE3
> +truncate -s $SIZE $FILE4
>  
>  LO1=$(losetup -f $FILE1 --show)
>  push_cleanup 'losetup -d $LO1'
> @@ -115,8 +117,10 @@ LO2=$(losetup -f $FILE2 --show)
>  push_cleanup 'losetup -d $LO2'
>  LO3=$(losetup -f $FILE3 --show)
>  push_cleanup 'losetup -d $LO3'
> +LO4=$(losetup -f $FILE4 --show)
> +push_cleanup 'losetup -d $LO4'
>  
> -[[ $LO1 && $LO2 && $LO3 && -b $LO1 && -b $LO2 && -b $LO3 ]]
> +[[ $LO1 && $LO2 && $LO3 && $LO4 && -b $LO1 && -b $LO2 && -b $LO3 && -b $LO4 ]]
>  DEV1=$(stat -c "%t:%T" $LO1)
>  DEV2=$(stat -c "%t:%T" $LO2)
>  DEV3=$(stat -c "%t:%T" $LO3)
> @@ -173,6 +177,7 @@ step "create partitions on loop devices"
>  
>  mk_partitions $LO1
>  mk_partitions $LO2
> +mk_partitions $LO4
>  
>  # Test invocation of kpartx with regular file here
>  LO2P1=/dev/mapper/$(basename $LO2)-foo1
> @@ -310,4 +315,21 @@ $KPARTX $KPARTX_OPTS -f -d $LO3
>  [[ -b /dev/mapper/$SPAN1 ]]
>  [[ -b /dev/mapper/$SPAN2 ]]
>  
> +step "test kpartx creation/deletion on an image file with no existing loopdev"
> +losetup -d $LO4
> +
> +OUTPUT=$($KPARTX $KPARTX_OPTS -v -a $FILE4 2>&1)
> +read loop dm < \
> +     <(sed -n  's/^add map \(loop[0-9]*\)p1 ([0-9]*:\([0-9]*\)).*$/\1 dm-\2/p' \
> +	   <<<$OUTPUT)
> +[[ $dm && $loop ]]
> +push_cleanup "dmsetup remove -f /dev/$dm"
> +push_cleanup "losetup -d /dev/$loop"
> +
> +[[ -b /dev/mapper/${loop}p1 ]]
> +$KPARTX -d $KPARTX_OPTS $FILE4
> +[[ ! -b /dev/mapper/${loop}p1 ]]
> +# /dev/$loop is _not_ automatically deleted
> +[[ -b /dev/${loop} ]]
> +
>  OK=yes
> -- 
> 2.19.0
