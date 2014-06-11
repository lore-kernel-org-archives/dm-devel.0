From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-thin: Export proper discard_granularity
Date: Wed, 11 Jun 2014 17:31:35 -0400
Message-ID: <20140611213134.GA22986@redhat.com>
References: <1402489929-16466-1-git-send-email-lczerner@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1402489929-16466-1-git-send-email-lczerner@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jun 11 2014 at  8:32am -0400,
Lukas Czerner <lczerner@redhat.com> wrote:

> Currently if the underlying device is discard capable and the
> discard_passdown is enabled, the discard_granularity will be inherited
> from that device.
> 
> This will pose a problem in the case that the device discard_granularity
> is smaller than thin volume chunk size, because in that case discard
> requests will not be chunk size aligned so it will be ignored by
> dm-thin.
> 
> Fix this by setting thin volume discard granularity to the bigger of the
> two max(device discard_granularity, thin volume chunk size). Strictly
> speaking it is not necessary to get the bigger of the two, because
> the thin volume chunk size will always be >= device discard_granularity.
> However I believe that the reason for this is only because dm-thin can
> not handle discard requests bigger than chunk size which is hopefully
> going to change soon. This way it is future proof.
> 
> RHBZ: 1106856
> 
> Reported-by: Zdenek Kabelac <zkabelac@fedoraproject.org>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Hi Lukas,

I missed this submission on dm-devel until now.  But I had already
picked this patch up earlier from the BZ, see the patch I staged in
linux-next here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=09869de57ed2728ae3c619803932a86cb0e2c4f8
