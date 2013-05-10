From: Joe Thornber <thornber@redhat.com>
Subject: Re: device mapper v/s block device driver
Date: Fri, 10 May 2013 11:35:31 +0100
Message-ID: <20130510103531.GG20880@debian>
References: <CAOb=_x+xHq06wCYpT0kSGN=u4LYqHw96wm4MC+xoXx-f2UvE1g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAOb=_x+xHq06wCYpT0kSGN=u4LYqHw96wm4MC+xoXx-f2UvE1g@mail.gmail.com>
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

On Thu, May 09, 2013 at 04:27:05PM -0600, neha naik wrote:
>        Are there any advantages of using block device driver instead of
> device mapper (or vice versa)

device-mapper is a framework for implementing virtual devices.  dm
devices can stack on each other nicely.

If you're writing a driver for real hardware, write a plain block
device driver.  Otherwise I'd start by looking at dm.

You may find your virtual dev can be more efficiently implemented
outside the dm framework.  For instance dm-cache can only see one bio
at a time within dm, which is tedious.  But make sure you've proved to
yourself and the community that the performance benefit is significant
enough to warrant reimplementing things that dm provides for free
(like bio splitting).

- Joe
