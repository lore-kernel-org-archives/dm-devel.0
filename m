From: Lavannya <swap_project@yahoo.com>
Subject: Question regarding multipath WWID
Date: Wed, 10 Jun 2009 12:01:26 -0700 (PDT)
Message-ID: <474792.20433.qm@web32002.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


Hi,

Recently  I am trying to test few  luns with multipath , in two of my

test server.  I worked throughly with PowerPath. 

I have few questions on multipath:

    -  what is the logic redhat is using  to create the WWID
       and what are the fields involved

    -  I am trying to test with the shared luns  (devices) between
       two nodes.  How i will identify  the device id in multipath.
       Though  as per Redhat ,  they are telling WWID is the identifier.
       But how i will identify the device id in the WWID?
       It is very much needed specially for shared luns.  In PowerPath, 
       generally  all the devices  are  identified  by the 
       lun id  /device id  then ,
       I use the Pseudo name (linux), for configuring the devices.  I will
       assume  that WWID is similar  as Pseudoid. If not, pl. correct me.

    -  Where can i match the device id in the WWID..

It will be really appreciated  , if someone clears  all my questions.

Thanks in advance.
    

    


      
