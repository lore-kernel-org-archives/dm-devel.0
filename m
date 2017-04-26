From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm ioctl: prevent stack leak in dm ioctl call
Date: Wed, 26 Apr 2017 02:06:09 +0100
Message-ID: <20170426010608.GD7433@agk-dp.fab.redhat.com>
References: <20170425233129.GA155598@google.com>
	<20170426001117.GA7433@agk-dp.fab.redhat.com>
	<CAEP91RFJTRk7Ux3W=1TMfgjzF1cMc5jXF+om4Qchh8RDx84MtQ@mail.gmail.com>
	<20170426004245.GB7433@agk-dp.fab.redhat.com>
	<CAEP91RG_9i80LpiGY+qSrcpcOt-F1ziUXAttSX2GUGFMsD8G6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAEP91RG_9i80LpiGY+qSrcpcOt-F1ziUXAttSX2GUGFMsD8G6g@mail.gmail.com>
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

On Tue, Apr 25, 2017 at 05:57:41PM -0700, Adrian Salido wrote:
> 1. param_kernel is allocated from stack and passed to copy_params
> 2. copy_params only copies up to param_kernel->data from user
> (param_kernel->data still contains stack contents)
> 3. in copy_params, since there are no params it will skip through and
> return param = dmi = param_kernel

after setting
  dmi->data_size = minimum_data_size;

and then         
  input_param_size = param->data_size;

> 4. that stale data is copied back to user
because it is incorrectly extending the buffer?
  param->data_size = sizeof(*param);
instead of continuing to use input_param_size?

Alasdair
