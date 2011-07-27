From: "Nigel Reed" <nigel@sysadmininc.com>
Subject: Multipath and primary pathing
Date: Wed, 27 Jul 2011 09:02:13 -0500
Message-ID: <3a5d511695512692af65265d6f9fa159.squirrel@www.sysadmininc.com>
Reply-To: nigel@sysadmininc.com,
        device-mapper development <dm-devel@redhat.com>
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
To: christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe, and dev team.

I didn't see a mailing list so I hope you don't mind a direct email.

I have a customer who is using a netapp with primary and partner pathing.
It looks like data is being sent between the two paths. The customer is
wanting data to go down only the primary path unless it fails, then switch
to the secondary partner path.

I've tried several different configurations but cannot seem to get it to
work.

They're using a combination of RHEL 4.9 and 5.6 with the earliest version
of multipath being 4.5

If you can give me some help, I'd appreciate it.

Thanks,
Nigel
-- 
Nigel Reed
