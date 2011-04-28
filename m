From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: DM RAID:  add region_size param
Date: Thu, 28 Apr 2011 15:17:34 -0400
Message-ID: <20110428191733.GA22745@redhat.com>
References: <201104281910.p3SJADWK029447@localhost6.localdomain6>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201104281910.p3SJADWK029447@localhost6.localdomain6>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 28 2011 at  3:10pm -0400,
Jonathan Brassow <jbrassow@redhat.com> wrote:

> Patch name: dm-raid-add-region_size-param.patch
> 
> Allow the user to specify region_size.  Ensure that the supplied value meets
> MD's constraints that the number of regions does not exceed 2^21.

Would it make any sense to have MD #define this 2^21 limit so that DM
can just include it?

Mike
