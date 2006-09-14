From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: Re: (no subject)
Date: Thu, 14 Sep 2006 10:00:06 -0400
Message-ID: <1158242406.4265.19.camel@linux-cxyg.rtp.netapp.com>
References: <8859E1A9-9C74-4188-A678-F97FD77A86FF@ysbl.york.ac.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8859E1A9-9C74-4188-A678-F97FD77A86FF@ysbl.york.ac.uk>
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


> Surely there is some way to tell device-mapper to leave things alone?  
> I simply need four drives that I can use as four separate units - no  
> RAIDing, nothing fancy, but this it seems impossible to tell the OS  
> that...
> 
Did you try blacklisting in /etc/multipath.conf?

I don't know which keyword for your setup - either blacklist or
devnode_blacklist.

Something like this should work:

devnode_blacklist {
       devnode "^sd[a-d]$"
}

_or_

blacklist {
       devnode "^sd[a-d]$"
}

To blacklist everything use devnode "*".

To verify the blacklist use the multipath command:
# multipath -d -v3 | grep sd
sda: blacklisted
