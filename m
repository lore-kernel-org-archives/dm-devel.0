From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm verity fec: Don't add data_blocks to block
Date: Tue, 7 Apr 2020 08:55:39 -0700
Message-ID: <CABCJKudWRmdyJAxjnTs+NiRJVnhDUQfzGO3sVKZNJoQ5Qi-aew@mail.gmail.com>
References: <CGME20200407065340epcas1p13e6e5ad6131f0a94d3ed1e8360353a82@epcas1p1.samsung.com>
 <317e0073-a6f7-4232-3b95-a4bc3ddbcdec@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <317e0073-a6f7-4232-3b95-a4bc3ddbcdec@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sunwook Eom <speed.eom@samsung.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, sunwook5492@gmail.com
List-Id: dm-devel.ids

On Mon, Apr 6, 2020 at 11:54 PM Sunwook Eom <speed.eom@samsung.com> wrote:
>
> Even if block type is metadata,
> block in verity_fec_decode() has already the right block number.
> So there is no need to add data_blocks to block.

Is this also true if the hashes are on a separate block device?

The idea here is that the error correction data was computed over both
data and hash blocks, as if they were concatenated, and we want to
calculate the logical block number based on that. I agree that the
code doesn't look quite right though. Should we use something like
this instead?

    if (type == DM_VERITY_BLOCK_TYPE_METADATA)
            block = block - v->hash_start + v->data_blocks;

Sami
