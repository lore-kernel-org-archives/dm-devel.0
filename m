From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: Re: [RFC][PATCH 0/3] persistent management feature for
	multipath-tools
Date: Fri, 23 Dec 2011 18:23:23 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D07A57E37@BTCMVEXC2-PRD.hq.netapp.com>
References: <EE2129A8E578DC4E94D643D6C1C1C67D078966CE@BTCMVEXC2-PRD.hq.netapp.com><1324332972.4565.46.camel@lapoo.opensvc.com>
	<4EF0AAC8.3010109@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4EF0AAC8.3010109@suse.de>
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

On Tue, Dec 20, 2011 at 9:03 PM, Hannes Reinecke <hare@suse.de> wrote:
>On 12/19/2011 11:16 PM, Christophe Varoqui wrote:
>> On lun., 2011-12-19 at 22:04 +0530, Chauhan, Vijay wrote:
>>> PERSISTENT RESERVE OUT/IN commands are currently not supported on
>mpath device. Any command sent to mpath device is routed to only one of
>the physical path (selected by path selector) from the active path
>group. PR OUT registration service action is one of the such use-case
>which fails as it expects all the physical path for the given mpath
>device to be registered. Due to these limitations, most of the cluster
>applications needs to manage persistent reservation through underlying
>physical path.
>>>
>> Persistent reservation is a path-centric command set. I don't see
>> clearly the benefit of folding (obfuscating?) it into the multipath
>> layer.
>>
>Agree. Persistent reservations is not something multipath should be
>handling internally. It'll just add functionality without any
>immediate gain.
>Plus we'd be incurring a support nightmare here.
>
>However, adding a _separate_ program for handling persistent
>reservations definitely would be a bonus, as this program could
>access multipath internals not otherwise accessible.
>And the integration into multipath doesn't gain us anything here;
>it's just used to figure out onto which paths PR should be updated.
>
>> Saving a few command lines ? I don't think there are wild admins
>playing
>> with PR without a clustering toolkit out there, so the tricky command
>> lines don't really matter.
>>
>Beg to disagree. 'Tricky command lines' are not the problem;
>figuring out multipath details (with the ever-changing output)
>definitely _is_.
>
>> I do maintain a clustering toolkit that handles PR, and I know this
>> feature would add code (multipath specific), not remove the current
>more
>> generic code.
>>
>> I also realize some other multipath implementations (PowerPath for
>one)
>> propose that feature. I'm curious to know the motivation.
>>
>> Am I the only one on the list thinking along this line ? Anyway, I
>have
>> no hard feelings against this work.
>>
>As did we, trying to implement a HA agent with persistent
>reservations :-)
>
>And hence I would definitely be glad having a tool setting
>persistent reservations on a multipathed device.
>Only I don't thing it should be built-into multipath itself.

Hannes, Thanks for your comment. Yes, I agree.

>
>Much like kpartx: you definitely need the functionality, but this
>functionality doesn't need to be part of multipath proper.

A new cli utility 'mpathpersist' and library 'libmpathpersist.so'
is introduced with this feature. 

To elaborate on each component functionality:

mpathpersist cli is responsible for validating user inputs 
& configuration and finally calls libmpathpersist.so library
APIs to perform pr management.

libmpathpersist.so library has all the intelligence for 
retrieving multipath information and performing persistent 
reservation on multipath device.

multipathd also uses libmpathpersist.so API's for handling 
persistent reservation on new path discovery and path reinstated. 

Also to be noted that this feature can be disabled in multipathd if 
reservation_key keyword is not mentioned multipath.conf.

mpathpersist cli 		     multipathd
    	|                         |  
    	|- calls lib API          |- Calls lib API for
      |  for PR management      | new path discovery
	!                         | or path reinstated 
      V                         |
libmpathpersist.so <------------!
   Library  --------------------------> libmultipath.so
              - uses libmultipath library
               for finding multipath details  	                                    
      
Is this something similar you are proposing? If not then can
you please give more insight for my understanding.


Currently I am working on the fix for Mike Snitzer's review
 comments and will resend these patches.

Diff stat below indicates the newly added and modified files
in multipath tools package: 
 Makefile                                       |    2 +
 Makefile.inc                                   |    2 +
 libmpathpersist/Makefile                       |   51 ++
 libmpathpersist/mpath_persist.c                |  897 ++++++++++++++++++++++++
 libmpathpersist/mpath_persist.h                |  241 +++++++
 libmpathpersist/mpath_persistent_reserve_in.3  |   80 +++
 libmpathpersist/mpath_persistent_reserve_out.3 |   92 +++
 libmpathpersist/mpath_pr_ioctl.c               |  572 +++++++++++++++
 libmpathpersist/mpath_pr_ioctl.h               |  111 +++
 libmpathpersist/mpath_updatepr.c               |   50 ++
 libmpathpersist/mpathpr.h                      |   55 ++
 libmultipath/config.h                          |    2 +
 libmultipath/configure.c                       |    1 +
 libmultipath/dict.c                            |  124 ++++
 libmultipath/discovery.c                       |    2 +-
 libmultipath/propsel.c                         |   44 ++
 libmultipath/propsel.h                         |    2 +
 libmultipath/structs.h                         |    4 +
 mpathpersist/Makefile                          |   30 +
 mpathpersist/main.c                            |  808 +++++++++++++++++++++
 mpathpersist/main.h                            |   28 +
 mpathpersist/mpathpersist.8                    |   96 +++
 multipathd/Makefile                            |    4 +-
 multipathd/cli.c                               |   12 +-
 multipathd/cli.h                               |   10 +-
 multipathd/cli_handlers.c                      |   73 ++
 multipathd/cli_handlers.h                      |    4 +
 multipathd/main.c                              |  151 ++++
 multipathd/main.h                              |   14 +
 29 files changed, 3554 insertions(+), 8 deletions(-)

Thanks,
Vijay
