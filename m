From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Tue, 23 Sep 2014 16:52:22 -0500
Message-ID: <3D595D3E-0986-4C0C-9FB3-657253CBEB42@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids


On Sep 23, 2014, at 11:51 AM, heinzm@redhat.com wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> Support discard in all RAID levels 1,10,4,5 and 6.
> 
> In case of RAID levels 4,5 and 6 we have to check for the capability
> to zero data on discards to avoid stripe data corruption.
> 
> If that capabilizy is missing on any disk in a RAID set,
> we have to disable discards.
> 
> 
> Signed-off-by: Heinz Mauelshagen <heinzm|redhat.com>

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

 brassow
