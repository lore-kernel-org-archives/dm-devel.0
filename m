From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH] Support HDIO_GETGEO on device-mapper volumes
Date: Fri, 10 Feb 2006 10:14:46 -0500
Message-ID: <43ECADE6.9020609@cfl.rr.com>
References: <43EBEDD0.60608@us.ibm.com> <43EC218A.9000402@cfl.rr.com>
	<43EC4B57.9000408@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43EC4B57.9000408@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids

Darrick J. Wong wrote:
> Phillip... are you the person working on dmraid support in Ubuntu?  
> For the first time, I boot Ubuntu off that HostRAID array this 
> afternoon without the need for a helper disk and with dmraid in the 
> initramfs.  I appreciated the howto. :)
>

Yes, I'm currently working on getting it nicely packaged, udebified, and 
integrated into the installer.  Might not make it in time for dapper. 
