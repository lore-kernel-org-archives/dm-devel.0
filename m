From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: prio ignored in multipath.conf
Date: Tue, 07 Jul 2009 16:05:28 +0100
Message-ID: <1246979128.20189.315.camel@breeves.fab.redhat.com>
References: <20090707144155.GA16220@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090707144155.GA16220@thumper2>
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

On Tue, 2009-07-07 at 09:41 -0500, Andy wrote:
> I am trying to change the path priorities on QLA2432 HBAs to a 3PAR array.
> The kernel is 2.6.31-rc1 and multipath tools v0.4.9
> 
> I created a small C program to change priorities (right now it just prints
> some info).  But, when I run multipath the verbose information keeps saying
> prio = const (controller setting), even though I have "prio  allant" (allant
> is the name of my prioritizer).  If I have "prio alllant" a global default
> it will run the code for the non-QLA2432/3PAR device, but not the devices
> that are under the control of the QLA2432.  It always sets prio to const and
> the QLA2432 paths.  This use to work at some point with older
> multipath/kernel versions.

It would help if you included your multipath.conf (or a link to it).

Regards,
Bryn.
