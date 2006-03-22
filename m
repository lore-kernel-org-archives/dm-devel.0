From: "bart brooks" <bart_brooks@hotmail.com>
Subject: striped multipath
Date: Wed, 22 Mar 2006 20:24:11 +0000
Message-ID: <BAY101-F13CA6B5AC7025528E7CFFB9DD90@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Hello,

Some brief background information; currently have the multipath-tools 
(0.4.5.49) working in RHEL 4.0 update 2.

I was wondering if it’s possible to define a logical device which is striped 
multipath.

Is it possible to create a new logical device using dmsetup, passing to it 
/dev/dm-# devices and specifying the striped information

If anybody has any information or sample configuration on the subject, it 
would be much appreciated.

Thanks in advance,
Bart Brooks
