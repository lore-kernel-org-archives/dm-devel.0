From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm ioctl: prevent stack leak in dm ioctl	call
Date: Thu, 27 Apr 2017 16:43:48 +0100
Message-ID: <20170427154348.GD5330@agk-dp.fab.redhat.com>
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Tue, Apr 25, 2017 at 05:33:19PM -0700, Adrian Salido wrote:
> Will update the patch to be clear
 
So at the moment, we're leaning towards just:

  param->data_size = offsetof(struct dm_ioctl, data)

to replace

  param->data_size = sizeof(*param);

in the caller.

Alasdair
