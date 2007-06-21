From: Markus <dieoma@gmail.com>
Subject: setup Pathpriority manually
Date: Thu, 21 Jun 2007 20:13:43 +0200
Message-ID: <e9cb6ff40706211113p3ea83a3di35658b19c5145b4d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

i do have an active-passive Storage where the LUN could be used by
both Controllers but one is bloody slow. I tried all
/sbin/mpath_prio_* ways do determin which is the "active" one but none
of them worked. Is there a way to set this manually? Is there a
different way to determin which is which rather than using the
existing Commands?

Thanks in advance
Markus
