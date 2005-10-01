From: Guy Coates <gmpc@sanger.ac.uk>
Subject: Re: [PATCH RFT/RFC 4/4] add dm-hp-sw hw handler
Date: Sat, 1 Oct 2005 09:27:01 +0100 (BST)
Message-ID: <Pine.OSF.4.44.0510010909370.3245698-100000@ecs2f.internal.sanger.ac.uk>
References: <1128109342.24395.26.camel@max> <433DA3AB.9010900@redhat.com>
	<1128113524.6536.63.camel@zezette>
	<20050930230415.GA9070@www.ewilts.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050930230415.GA9070@www.ewilts.org>
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
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

> - I've got 4 inhouse and a 5th on the way.
>
> > EVA4000 , 6000, 8000 don't need no hardware handler (afaik).
>
> These are all active/active.  I don't have any to play with yet -
> probably next year.

That isn't entirely true; although they are active/active, there is still
a preferred LUN for each controller.  (see bad ascii art)


             SAN FABRIC
|                            |
|                            |
Controller1<--Internal bus-->Controller2
|
|
LUN

Read IO to controller1 goes direct to the LUN. Read IOs to controller2
cross an internal bus to controller1, which can limit performance.


However, if IO is going consistently to the non-preffered controller, the
EVA will flip the lun over and make that controller the preffered
controller.

The upshot was we found we got better, more consistent, performance when
we used the group-by-serial rather than multibus path_grouping_policy for
the EVA8000.

Allegedly, there is a way to find out which controller is the preffered
one for each lun, but I don't know what it is.


Cheers,


Guy



-- 
Dr. Guy Coates,  Informatics System Group
The Wellcome Trust Sanger Institute, Hinxton, Cambridge, CB10 1HH, UK
Tel: +44 (0)1223 834244 x 6925
Fax: +44 (0)1223 494919
