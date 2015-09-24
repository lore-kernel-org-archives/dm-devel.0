From: "Schunack, Daniel" <dschunack@web.de>
Subject: multipath with alias and binding file
Date: Thu, 24 Sep 2015 14:19:40 +0200
Message-ID: <5603EA5C.1050105@web.de>
Reply-To: dschunack@web.de, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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

Hello,

we use alias on our OEL and Redhat Server. In RHEL5/OEL5 we use the 
multipath.conf to set the aliases on the system. With RHEL5/OEL6 we use 
the /etc/multipath/binding file to set alias.
It works great, but with the update to OEL6.7 the multipathd doesn't use 
our alias in /etc/multipath/binding. The multipathd add the WWIDs again 
at the end of the File.
The Oracle Support says it's not allowed to set alias with the binding 
file. It's only supported to do this in the multipath.conf.
My Question is: Is this correct and it's not allowed to set alias with 
binding file and the only way to do this is the multipath.conf?

Best regards

Daniel
