From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm verity fec: Don't add data_blocks to block
Date: Thu, 9 Apr 2020 15:34:41 -0700
Message-ID: <CABCJKueXaqJz2n9sfAOWsHGD8qgL8VzD5qWcqsK7cA6zrM_Yrw@mail.gmail.com>
References: <CGME20200407065340epcas1p13e6e5ad6131f0a94d3ed1e8360353a82@epcas1p1.samsung.com>
 <317e0073-a6f7-4232-3b95-a4bc3ddbcdec@samsung.com> <CABCJKudWRmdyJAxjnTs+NiRJVnhDUQfzGO3sVKZNJoQ5Qi-aew@mail.gmail.com>
 <4a4a914c-c020-4b45-7cba-5aed816f0545@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4a4a914c-c020-4b45-7cba-5aed816f0545@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sunwook Eom <speed.eom@samsung.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, sunwook5492@gmail.com
List-Id: dm-devel.ids

On Wed, Apr 8, 2020 at 11:40 PM Sunwook Eom <speed.eom@samsung.com> wrote:
> If you don't mind, I'll send a new version of this patch.

Sounds good, thanks! Please also add a Fixes tag to the next version:

Fixes: a739ff3f543af ("dm verity: add support for forward error correction")

Sami
