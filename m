From: nishant mungse <nishantmungse@gmail.com>
Subject: Doubt regarding dm-raid1
Date: Thu, 27 Jan 2011 21:03:07 -0800
Message-ID: <AANLkTi=ryfEU9VOBE7qBaecWnJ93h9tdYt0cNb388vXC@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

   Hi Malahal

    Thanks for reply. I am not able to understand what  this
    "INIT_WORK(&ms->kmirrord_work, do_mirror)" function does. It  is written
    in mirror_ctr of dm-raid1. What i think is whenever a bio comes dm_mirror
    will be called if that is case then why this is written in mirror_ctr.


 Regards,
 Nishant.
