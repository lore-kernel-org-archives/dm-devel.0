From: Sunwook Eom <speed.eom@samsung.com>
Subject: Re: [PATCH] dm verity fec: fix hash block number in
 verity_fec_decode
Date: Mon, 13 Apr 2020 13:31:27 +0900
Message-ID: <8a6d104e-4a2b-c393-567f-95bc06f6763a@samsung.com>
References: <CGME20200410035424epcas1p2d47ca3a171af6a895af17d86e2838269@epcas1p2.samsung.com>
        <b8de2c4b-d8cf-2bdb-f4cf-5b10faf48955@samsung.com>
        <CABCJKueSJ4sXHL5xnB5LQVW_6od2+_TEp0y_vv1gdi=yBB1Zfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CABCJKueSJ4sXHL5xnB5LQVW_6od2+_TEp0y_vv1gdi=yBB1Zfg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, =?UTF-8?B?6rCV66y47LKg?= <mcneo.kang@samsung.com>, sunwook5492@gmail.com, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids


On 20. 4. 11. 오전 12:41, Sami Tolvanen wrote:
> On Thu, Apr 9, 2020 at 8:54 PM Sunwook Eom <speed.eom@samsung.com> wrote:
>> The error correction data is computed as if data and hash blocks
>> were concatenated. But hash block number is start from v->hash_start.
>> So, we have to calculate hash block number based on that.
>>
>> Fixes: a739ff3f543af ("dm verity: add support for forward error correction")
>> Signed-off-by: Sunwook Eom <speed.eom@samsung.com>
>> ---
>>    drivers/md/dm-verity-fec.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
>> index 49147e634046..fb41b4f23c48 100644
>> --- a/drivers/md/dm-verity-fec.c
>> +++ b/drivers/md/dm-verity-fec.c
>> @@ -435,7 +435,7 @@ int verity_fec_decode(struct dm_verity *v, struct
>> dm_verity_io *io,
>>        fio->level++;
>>
>>        if (type == DM_VERITY_BLOCK_TYPE_METADATA)
>> -        block += v->data_blocks;
>> +        block = block - v->hash_start + v->data_blocks;
>>
>>        /*
>>         * For RS(M, N), the continuous FEC data is divided into blocks of N
> Thank you for the patch!
>
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
>
> Sami
>
>
Add CC : LKML <linux-kernel@vger.kernel.org>
