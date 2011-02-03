From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Using the dm tools to create a writable "mirror" of
 a	physical disk
Date: Wed, 02 Feb 2011 19:17:41 -0500
Message-ID: <4D49F425.1000203@cfl.rr.com>
References: <AANLkTinqdTZnqX7qXthQHqa+bFmonCJOJ1ShpkAosB_T@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTinqdTZnqX7qXthQHqa+bFmonCJOJ1ShpkAosB_T@mail.gmail.com>
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
Cc: Anders Andersson <pipatron@gmail.com>
List-Id: dm-devel.ids

On 02/02/2011 05:31 PM, Anders Andersson wrote:
> Good evening! I was recently given the task of trying to salvage files
> from a 1.5TB harddrive that was accidentally formatted and/or
> repartitioned. Normally I would do a 1:1 copy of the whole drive to a
> file and operate on that, but I simply do not have that much room this
> time.
>
> Ideally I would like to create a writable snapshot in the same way as
> I do with my LVM volumes, storing the changes in a smaller file or in
> another block device so that I can experiment freely without worrying
> about destroying anything else on the drive. Is this possible
> (probably) and easy (probably not?) with any device mapper tools? I'm
> not really sure where I should begin looking, because dmsetup is
> probably pretty low-level.

Yep, you need to use dmsetup.  Documentation/device-mapper/snapshot.txt 
in the kernel sources documents how.
