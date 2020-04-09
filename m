From: Sunwook Eom <speed.eom@samsung.com>
Subject: Re: [PATCH] dm verity fec: Don't add data_blocks to block
Date: Thu, 9 Apr 2020 15:40:07 +0900
Message-ID: <4a4a914c-c020-4b45-7cba-5aed816f0545@samsung.com>
References: <CGME20200407065340epcas1p13e6e5ad6131f0a94d3ed1e8360353a82@epcas1p1.samsung.com>
        <317e0073-a6f7-4232-3b95-a4bc3ddbcdec@samsung.com>
        <CABCJKudWRmdyJAxjnTs+NiRJVnhDUQfzGO3sVKZNJoQ5Qi-aew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CABCJKudWRmdyJAxjnTs+NiRJVnhDUQfzGO3sVKZNJoQ5Qi-aew@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, sunwook5492@gmail.com
List-Id: dm-devel.ids


On 20. 4. 8. 오전 12:55, Sami Tolvanen wrote:
> On Mon, Apr 6, 2020 at 11:54 PM Sunwook Eom <speed.eom@samsung.com> wrote:
>> Even if block type is metadata,
>> block in verity_fec_decode() has already the right block number.
>> So there is no need to add data_blocks to block.
> Is this also true if the hashes are on a separate block device?
>
> The idea here is that the error correction data was computed over both
> data and hash blocks, as if they were concatenated, and we want to
> calculate the logical block number based on that. I agree that the
> code doesn't look quite right though. Should we use something like
> this instead?
>
>      if (type == DM_VERITY_BLOCK_TYPE_METADATA)
>              block = block - v->hash_start + v->data_blocks;
>
> Sami
>
>
You're right. I missed the case that hashes are on a separate block device.

And, the code you wrote seems to be correct.

If you don't mind, I'll send a new version of this patch.

Thank you for the review.


Sunwook
