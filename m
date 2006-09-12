From: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: lvresize fails with "reload ioctl failed: Invalid
	argument"
Date: Tue, 12 Sep 2006 22:57:10 +0200
Message-ID: <45071F26.1090108@free.fr>
References: <ee20kk$s7u$1@sea.gmane.org>	<20060910221427.GF13859@agk.surrey.redhat.com>	<20060911141916.GC13522@percy.comedia.it>	<450592C5.50905@free.fr>	<20060911170527.GE13522@percy.comedia.it>	<4505C3BB.1050000@free.fr>
	<4505FD02.10309@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4505FD02.10309@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Le 12.09.2006 02:19, Jun'ichi Nomura a =E9crit :
> Hi Laurent,
>=20
> Laurent Riffard wrote:
>>>>>>>  device-mapper: reload ioctl failed: Invalid argument
> ...
>>> works for me with 2.6.17-4mdv kernel
>>> maybe something related to your kernel version?
>>
>> Yes, you seem to be right: it does work with 2.6.17-2mdv or=20
>> 2.6.17-4mdv, but it fails with 2.6.18-rc6-mm1.
>=20
> I reproduced the problem on my host, too.
> I found a change in -mm which would cause this problem
> and attached patch fixed it.
>=20
> I'll post it to linux-kernel as well.
>=20
> Thanks,

Hi Jun'ichi,

I can confirm that your patch solved this problem.=20

- 2.6.18-rc6 works
- 2.6.18-rc6-mm1 fails
- 2.6.18-rc6-mm2 fails
- 2.6.18-rc6-mm2 + correct-add_bd_holder-return-value.patch works

Thanks!
--
laurent

> -----------------------------------------------------------------------=
-
>=20
> If a matching bd_holder is found in bd_holder_list,
> add_bd_holder() completes its job by just incrementing the reference co=
unt.
> In this case, it should be considered as success but it used to return =
'fail'
> to let the caller free bd_holder.
> Fixed it to return success and free given object by itself.
>=20
> Also, if either one of symlinking fails, the bd_holder should not
> be added to the list so that it can be discarded later.
> Otherwise, the caller will free bd_holder which is in the list.
>=20
> This patch is neccessary only for -mm (later than 2.6.18-rc1-mm1).
>=20
>  fs/block_dev.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>=20
> diff -urp linux-2.6.18-rc5-mm1.orig/fs/block_dev.c linux-2.6.18-rc5-mm1=
/fs/block_dev.c
> --- linux-2.6.18-rc5-mm1.orig/fs/block_dev.c	2006-09-11 19:33:35.000000=
000 -0400
> +++ linux-2.6.18-rc5-mm1/fs/block_dev.c	2006-09-11 19:21:46.000000000 -=
0400
> @@ -655,8 +655,8 @@ static void free_bd_holder(struct bd_hol
>   * If there is no matching entry with @bo in @bdev->bd_holder_list,
>   * add @bo to the list, create symlinks.
>   *
> - * Returns 0 if @bo was added to the list.
> - * Returns -ve if @bo wasn't used by any reason and should be freed.
> + * Returns 0 if symlinks are created or already there.
> + * Returns -ve if something fails and @bo can be freed.
>   */
>  static int add_bd_holder(struct block_device *bdev, struct bd_holder *=
bo)
>  {
> @@ -669,7 +669,9 @@ static int add_bd_holder(struct block_de
>  	list_for_each_entry(tmp, &bdev->bd_holder_list, list) {
>  		if (tmp->sdir =3D=3D bo->sdir) {
>  			tmp->count++;
> -			return -EEXIST;
> +			/* We've already done what we need to do here. */
> +			free_bd_holder(bo);
> +			return 0;
>  		}
>  	}
> =20
> @@ -682,7 +684,8 @@ static int add_bd_holder(struct block_de
>  		if (ret)
>  			del_symlink(bo->sdir, bo->sdev);
>  	}
> -	list_add_tail(&bo->list, &bdev->bd_holder_list);
> +	if (ret =3D=3D 0)
> +		list_add_tail(&bo->list, &bdev->bd_holder_list);
>  	return ret;
>  }
>=20
