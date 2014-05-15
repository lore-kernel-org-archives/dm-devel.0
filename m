From: Tommaso <tomcec@gmail.com>
Subject: Re: Problem with multipath
Date: Thu, 15 May 2014 13:10:05 +0000 (UTC)
Message-ID: <loom.20140515T150742-91@post.gmane.org>
References: <CADpTdPQmGB9-PvLciGHdLeBa6D4CACMT=UxmyLWQLa4xMXe6OA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Mindaguas, I found the same problem
on a Scientific Linux 6.3 (SL 5.4 was working perfectly).

Did you find the solution? I found that the problem
is just about multiipathd, I mean that block 
devices are there but multipath cannot build
a map on them.

On my machines I have many hundreds of LUs.

Thanks,
Tommaso
