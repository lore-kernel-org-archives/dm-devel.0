From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: how do I re-synchronize with the Master mirror device?
Date: Tue, 19 Jun 2007 13:20:01 -0500
Message-ID: <57F02999-B101-42EC-BFE9-3A59CB8FBCAF@redhat.com>
References: <20070619001410.GA4442@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070619001410.GA4442@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Are you using disk logging?

Are you using LVM to setup the mirrors, or are you doing it yourself  
through dmsetup?

  brassow

On Jun 18, 2007, at 7:14 PM, malahal@us.ibm.com wrote:

> I have a dm-mirror setup where the mirror devices could occasionally
> timeout due to network congestion or recovery at the device. If a  
> device
> times out, it goes out of sync with the Master. How do I sync it back?
> Only few regions would have gone out of sync with the Master. Is it
> possible to sync only the regions that have gone out of sync?
>
> Thank you for your time.
>
> --Malahal.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
