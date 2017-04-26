From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm ioctl: prevent stack leak in dm ioctl call
Date: Wed, 26 Apr 2017 01:11:17 +0100
Message-ID: <20170426001117.GA7433@agk-dp.fab.redhat.com>
References: <20170425233129.GA155598@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170425233129.GA155598@google.com>
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

On Tue, Apr 25, 2017 at 04:31:29PM -0700, Adrian Salido wrote:
> Struct dm_ioctl has some padding/data that is not explicitly cleared
> before copying to user. This can cause kernel stack contents to be
> leaked to user space.

Please be more precise here, explaining which part of the buffer 
and under exactly what circumstances you have found that uninitialised 
content gets returned to userspace.

Alasdair
