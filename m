From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/7] Data integrity protection with
 dm-integrity and dm-crypt
Date: Thu, 16 Mar 2017 15:12:24 -0400
Message-ID: <20170316191224.GA31496@redhat.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
	<20170316143944.19843-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170316143944.19843-1-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 16 2017 at 10:39am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> These are additional patches to previously submitted integrity protection commits,
> based on for-next branch in Mike's DM tree.
> 
> Most of them probably can be folded-in, patches are separated for better readability.
> 
> The last patch for large encryption sectors is a new feature but because it depends
> on all previous patches it is posted in this series.

I've picked all these up and staged in linux-next and dm-4.12, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.12

(you'll note that I folded them and tweaked headers accordingly)
