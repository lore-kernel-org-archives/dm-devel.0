From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 1/2] md: dm-verity: aggregate crypto API calls
Date: Mon, 26 Mar 2018 09:31:23 +0300
Message-ID: <CAOtvUMeKOQMLa8hf_0A=Pw8ERQGq2Cir48qWePEY0+Eq0pyRMw@mail.gmail.com>
References: <1522003290-27243-1-git-send-email-yael.chemla@foss.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522003290-27243-1-git-send-email-yael.chemla@foss.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yael Chemla <yael.chemla@foss.arm.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Linux kernel mailing list <linux-kernel@vger.kernel.org>, ofir.drang@gmail.com, Yael Chemla <yael.chemla@arm.com>
List-Id: dm-devel.ids

On Sun, Mar 25, 2018 at 9:41 PM, Yael Chemla <yael.chemla@foss.arm.com> wrote:
>  Current implementation makes multiple crypto API calls per block
>  implementation makes multiple crypto API calls per single block,
>  forcing underlying crypto tfm implementation to "stop & go",
>  leading to under utilization of HW engines.
>  To fix it unify calls to crypto init/update/final into a digest call
>  with a single sg which contains multiple buffers.
>  This is also needed as an enabler for the next patch in the series.
>
>
> Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>
> ---
>  drivers/md/dm-verity-target.c | 220 ++++++++++++++++++++++++------------------
>  1 file changed, 127 insertions(+), 93 deletions(-)



Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
