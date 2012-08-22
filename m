From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Tue, 21 Aug 2012 21:04:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1208212103310.1653@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
	<Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
	<20120821163329.GA21395@freewill.lab.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120821163329.GA21395@freewill.lab.equallogic.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim Ramsay <jim_ramsay@dell.com>
Cc: dm-devel@redhat.com, Jason_Shamberger@dell.com, agk@redhat.com, Kevin_OKelley@dell.com
List-Id: dm-devel.ids

/* a sample program that makes a table of million entries and uploads it 
via dm message */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <libdevmapper.h>

#define N_DEVICES		3
#define TABLE_SIZE		1000000

#define MSG_SIZE_LIMIT		45000
#define MSG_SIZE_RESERVED	20

static int table[TABLE_SIZE];
static char buffer[MSG_SIZE_LIMIT];

static void print_hex(char **s, unsigned hex)
{
	char *p = *s;
	int b;
	for (b = 0; hex >> 4 >> b; b += 4) ;
	do {
		char c = (hex >> b) & 0xf;
		if (c <= 9) c += '0';
		else c += 'A' - 10;
		*p++ = c;
	} while ((b -= 4) >= 0);
	*s = p;
}

int main(void)
{
	int i, index;
	int val;

	val = time(NULL) % N_DEVICES;
	for (i = 0; i < TABLE_SIZE; i++) {
		table[i] = val;
		if (++val >= N_DEVICES) val = 0;
	}

	index = 0;
	while (index < TABLE_SIZE) {
		struct dm_task *dmt;
		char *ptr;
		strcpy(buffer, "set-table ");
		ptr = strchr(buffer, 0);
		print_hex(&ptr, index);
		while (index < TABLE_SIZE && ptr - buffer < MSG_SIZE_LIMIT - MSG_SIZE_RESERVED) {
			*ptr++ = ':';
			print_hex(&ptr, table[index]);
			*ptr++ = ' ';
			index++;
		}
		if (ptr - buffer > MSG_SIZE_LIMIT) {
			fprintf(stderr, "buffer overflow\n");
			exit(1);
		}
		ptr[-1] = 0;

		dmt = dm_task_create(DM_DEVICE_TARGET_MSG);
		if (!dmt) fprintf(stderr, "dm_task_create failed\n"), exit(1);
		if (!dm_task_set_name(dmt, "switch")) fprintf(stderr, "dm_task_set_name failed\n"), exit(1);
		if (!dm_task_set_sector(dmt, 0)) fprintf(stderr, "dm_task_set_sector failed\n"), exit(1);

		if (!dm_task_set_message(dmt, buffer)) fprintf(stderr, "dm_task_set_message failed\n"), exit(1);

		if (!dm_task_run(dmt)) fprintf(stderr, "dm_task_run failed\n"), exit(1);

		dm_task_destroy(dmt);
	}

	return 0;
}
