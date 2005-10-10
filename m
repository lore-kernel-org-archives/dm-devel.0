From: Hubert <hubgor@poczta.fm>
Subject: Re: Dm-devel ioctl-skip-lockfs patch
Date: Mon, 10 Oct 2005 16:31:17 +0200
Message-ID: <434A7B35.9030903@poczta.fm>
References: <434A431C.1060208@poczta.fm>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <434A431C.1060208@poczta.fm>
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

With reference to my previous message 
https://www.redhat.com/archives/dm-devel/2005-October/msg00023.html
I know what has been done wrong. In ioctl-skip-lockfs patch in function 
`do_suspend' was declared "int dm_lockfs = 1;" but  after all references 
are  to the  variable "do_lockfs" whose is course undeclared.

Hubert


----------------------------------------------------------------------
Daj sie skusic... >>> http://link.interia.pl/f18bc
