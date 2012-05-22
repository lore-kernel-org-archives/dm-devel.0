From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: working with dm-raid module
Date: Tue, 22 May 2012 13:59:05 -0500
Message-ID: <9CAF1B15-7834-490B-9B38-106185112BF2@redhat.com>
References: <DFC2D280-3C82-41F4-AA4C-1EE88A6BAEDA@tversu.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DFC2D280-3C82-41F4-AA4C-1EE88A6BAEDA@tversu.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Zhukov <zhukov@tversu.ru>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On May 19, 2012, at 2:41 PM, Andrew Zhukov wrote:

> Hello!
> 
> I am engineer in Tver State University. We would like to use dm-raid driver in our storage system. But we must understand how we can rebuild the array (e.g raid1) and how mark a disk as failed. I have not found any documentation about it. Could you tell how to do it? 

The mapping table contains all of the possible options you should need.  The options are listed in linux/Documentation/device-mapper/dm-raid.txt.

I have thought that it might also be useful to notify the kernel of a drive failure (or a drive returning to life) without having to load a new mapping table.  This could be done through the DM message interface.  If you find that this is a necessary thing, we could talk about that too.

 brassow
