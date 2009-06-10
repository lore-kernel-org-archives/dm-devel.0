From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: Can SCSI commands trigger the reinit of a disabled path?
Date: Wed, 10 Jun 2009 23:55:36 +0800
Message-ID: <d364733c0906100855m3804864emce5a590f465daca8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

I went through the multipath code and found there was hardware handler
for specified hardware, such as emc.  When init path, it will use the
trespass command given by the handler. Does this mean it only support
the A/PF mode of array? When SCSI commands,  such as SCSI PR, are sent
to a disabled path, will trespass be triggered?

Thanks,

-- 
Xie Gang
