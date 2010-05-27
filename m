From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 1/2] dm: prevent table type changes after
	initial table load
Date: Wed, 26 May 2010 23:41:11 -0400
Message-ID: <AANLkTilRW0QnUYmjnlbntkqOYYbBEiG2gjr2nP0044zi@mail.gmail.com>
References: <1274798593-19418-1-git-send-email-snitzer@redhat.com>
	<1274798593-19418-2-git-send-email-snitzer@redhat.com>
	<4BFDE2EA.80009@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BFDE2EA.80009@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 26, 2010 at 11:11 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi Mike,
>
> Some small comments below.
>
> For others,
> Acked-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
>
> On 05/25/2010 11:43 PM +0900, Mike Snitzer wrote:
>> @@ -1176,6 +1176,21 @@ static int table_load(struct dm_ioctl *p
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 /* Protect md->type against concurrent table loads. */
>> + =A0 =A0 dm_lock_md_type(md);
>> + =A0 =A0 if (dm_get_md_type(md) =3D=3D DM_TYPE_NONE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* initial table load, set md's type based on =
table's type */
>> + =A0 =A0 =A0 =A0 =A0 =A0 dm_set_md_type(md, t);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dm_set_md_type(md, dm_table_get_type(t));
>
> Although I don't impose this interface, I feel it is straightforward
> for this function. =A0Then, dm_set_md_type() just set the type in md->typ=
e;
>
> =A0 =A0 =A0 =A0void dm_set_md_type(struct mapped_device *md, unsigned typ=
e)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0md->type =3D type;
> =A0 =A0 =A0 =A0}

Looks good, I'll change it as you suggest.

Thanks,
Mike
