From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH] dm-thinp: new device mapper target to thin
 provision storage
Date: Wed, 29 Sep 2010 09:41:05 -0400
Message-ID: <4CA341F1.70305@cfl.rr.com>
References: <1285706977.22966.20.camel@o> <4CA261C5.7070005@cfl.rr.com>
	<1285759512.23010.1.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1285759512.23010.1.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

On 9/29/2010 7:25 AM, Heinz Mauelshagen wrote:
> On Tue, 2010-09-28 at 17:44 -0400, Phillip Susi wrote:
>> How is this different than snapshotting a zero target?
> 
> Like Hanness mentioned: you can free space.

Could you clarify that a bit?  Is space only freed if you reduce the
length of a device?  You can't do the same with a snapshot?
