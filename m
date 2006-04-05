From: Abhishek Gupta <agupta@cs.ubc.ca>
Subject: Target needs access to mapped device
Date: Tue, 4 Apr 2006 22:58:31 -0700 (PDT)
Message-ID: <Pine.LNX.4.60.0604042215210.24876@okanagan.cs.ubc.ca>
References: <20060321170118.1721674450@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060321170118.1721674450@hormel.redhat.com>
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

Hi everyone,

I need to be able to set a logical device to read-only from the 
target of the logical device. In other words, I need the following 
function in dm-table.c:

void dm_table_set_mode(struct dm_table *t, int mode)
{
 	t->mode = mode;
}

There is already a function dm-table.c:dm_table_get_mode(). Will it be 
feasible to 
include its counterpart too?

Thanks

Abhishek
