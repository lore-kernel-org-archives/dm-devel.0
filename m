From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm verity fec: Fix memory leak in
	verity_fec_ctr
Date: Tue, 17 Mar 2020 09:09:02 -0700
Message-ID: <CABCJKuf6X6fi8fqF_z0HYX0rnD8b98=L-8Y31=OiPEVzw0d1_Q@mail.gmail.com>
References: <5e70da92.1c69fb81.c30ac.5d5cSMTPIN_ADDED_BROKEN@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5e70da92.1c69fb81.c30ac.5d5cSMTPIN_ADDED_BROKEN@mx.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Shetty, Harshini X (EXT-Sony Mobile)" <Harshini.X.Shetty@sony.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "Takeuchi,
	Shingo (SOMC)" <Shingo.Takeuchi@sony.com>, "Nagaraju,
	Srinavasa (SOMC)" <Srinavasa.Nagaraju@sony.com>, "Khasnis,
	Soumya X (EXT-Sony Mobile)" <Soumya.Khasnis@sony.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Takahashi,
	Masaya (SOMC)" <Masaya.Takahashi@sony.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 17, 2020 at 7:11 AM Shetty, Harshini X (EXT-Sony Mobile)
<Harshini.X.Shetty@sony.com> wrote:
>
> Fix below kmemleak detected in verity_fec_ctr.
> output_pool is allocated for each dm-target device.
> But it is not freed when dm-table for the target
> is removed.Hence Free the output buffer in destructor
> function verity_fec_dtr

Good catch, thanks for the fix!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
