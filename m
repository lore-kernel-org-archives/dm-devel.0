From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm ioctl: prevent stack leak in dm ioctl call
Date: Wed, 26 Apr 2017 01:42:45 +0100
Message-ID: <20170426004245.GB7433@agk-dp.fab.redhat.com>
References: <20170425233129.GA155598@google.com>
	<20170426001117.GA7433@agk-dp.fab.redhat.com>
	<CAEP91RFJTRk7Ux3W=1TMfgjzF1cMc5jXF+om4Qchh8RDx84MtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAEP91RFJTRk7Ux3W=1TMfgjzF1cMc5jXF+om4Qchh8RDx84MtQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Adrian Salido <salidoa@google.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Tue, Apr 25, 2017 at 05:33:19PM -0700, Adrian Salido wrote:
> it's actually the data portion of the struct under a custom user ioctl
> where (param_kernel->data_size - minimum_data_size) <
> sizeof(param_kernel->data)
> Will update the patch to be clear

Yes - but before updating the patch, we need to be clearer about the
requirements of the ioctl here.

Why are two different minimum data sizes used?

If we let userspace send a truncated dm_ioctl struct, why are we not
returning the same truncated one?

Is this the bug?
  param->data_size = sizeof(*param);

Alasdair
