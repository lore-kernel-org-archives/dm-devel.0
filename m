From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: Need Help
Date: Thu, 17 Jan 2008 13:34:23 -0800
Message-ID: <1200605663.7183.81.camel@linuxchandra>
References: <EEBC5C82F965344199BFA3E6047FE13302E8FA@SAUSEXMB2.amd.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <EEBC5C82F965344199BFA3E6047FE13302E8FA@SAUSEXMB2.amd.com>
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

On Thu, 2008-01-17 at 15:10 -0600, Nath, Varun wrote:
> This is what is happening as soon as the system comes up. 
> 
> There are no multipathing devices created. Once I run the multipath
> command only then the /dev/mpath/mpath# devices get created. It looks
> like I am missing some thing when the system boots up. The system has
> the multipathd start up script in /etc/rc3.d. 

What does "chkconfig --list multipathd" show ?

And what is default level you boot to (i.e what is initdefault
in /etc/inittab) ?

> 
> Any suggestions?
> 

<snip>

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
