From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: tests for new dm event code
Date: Wed, 20 Sep 2017 07:42:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709200729560.26957@file01.intranet.prod.int.rdu2.redhat.com>
References: <13FDF4B8-4807-4941-B55F-B01140C4EA13@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <13FDF4B8-4807-4941-B55F-B01140C4EA13@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 14 Sep 2017, Brassow Jonathan wrote:

> Mikulas,
> 
> Do you have any tests for the new dm event code you added a while back? 
> (https://bugzilla.redhat.com/show_bug.cgi?id=1475380#c3)  I?d like to 
> give QA instructions for how to perform regression testing on it so we 
> can get their full QA ack.
> 
> Thanks,
>  brassow

I've created this program to test it - it monitor for dm device creation, 
deletion and events.

It also needs the recent patch that fixes alignment that I've just sent to 
dm-devel.

Mikulas


#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <poll.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <linux/dm-ioctl.h>

#include <iostream>
#include <map>

using namespace std;

#ifndef DM_DEV_ARM_POLL
#define DM_DEV_ARM_POLL	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD + 1, struct dm_ioctl)
#endif

static void fill_dm(struct dm_ioctl *dmi_p, size_t size)
{
	memset(dmi_p, 0, size);
	dmi_p->version[0] = DM_VERSION_MAJOR;
	dmi_p->version[1] = DM_VERSION_MINOR;
	dmi_p->version[2] = DM_VERSION_PATCHLEVEL;
	dmi_p->flags = 0x4;
	dmi_p->data_start = offsetof(struct dm_ioctl, data);
	dmi_p->data_size = size;
}

int main(void)
{
	int h, r;
	struct dm_ioctl dmi;
	map<string,uint32_t> last_event;

	h = open("/dev/mapper/control", O_RDWR);
	if (h < 0) perror("/dev/mapper/control"), exit(1);

	fill_dm(&dmi, sizeof dmi);
	r = ioctl(h, DM_VERSION, &dmi);
	if (r) perror("DM_VERSION"), exit(1);
	cout << "dm version: " << dmi.version[0] << "," << dmi.version[1] << "," << dmi.version[2] << endl << flush;
	if (dmi.version[0] != 4 || dmi.version[1] < 37) fprintf(stderr, "old kernel version, it doesn't support polling\n"), exit(1);

	while (1) {
		fill_dm(&dmi, sizeof dmi);
		r = ioctl(h, DM_DEV_ARM_POLL, &dmi);
		if (r) perror("DM_DEV_ARM_POLL"), exit(1);

		size_t sz = sizeof(struct dm_ioctl);
bigger:
		struct dm_ioctl *dmi_p = (struct dm_ioctl *)malloc(sz);
		if (!dmi_p) perror("malloc"), exit(1);
		fill_dm(dmi_p, sz);
		r = ioctl(h, DM_LIST_DEVICES, dmi_p);
		if (r) perror("DM_LIST_DEVICES"), exit(1);
		if (dmi_p->flags & DM_BUFFER_FULL_FLAG) {
			sz *= 2;
			free(dmi_p);
			goto bigger;
		}

		map<string,uint32_t> this_event;

		if (dmi_p->data_start < dmi_p->data_size) {
			struct dm_name_list *nl = (struct dm_name_list *)((char *)dmi_p + dmi_p->data_start);
			while (1) {
				uint32_t event;
				event = *(uint32_t *)(((uintptr_t)(strchr(nl->name, 0) + 1) + 7) & ~7);
				string name = nl->name;
				map<string,uint32_t>::iterator it = last_event.find(name);
				if (it == last_event.end()) {
					cout << "New device '" << name << "', event number " << event << endl;
				} else {
					if (it->second != event)
						cout << "New event on device '" << name << "', event number " << event << endl;
					last_event.erase(it);
				}
				this_event[name] = event;
				if (!nl->next)
					break;
				nl = (struct dm_name_list *)((char *)nl + nl->next);
			}
		}
		for (map<string,uint32_t>::iterator it = last_event.begin(); it != last_event.end(); it++)
			cout << "Deleted device '" << it->first << "'" << endl;
		free(dmi_p);
		cout << flush;

		last_event = this_event;

		struct pollfd fd;
		fd.fd = h;
		fd.events = POLLIN;
		r = poll(&fd, 1, -1);
		if (r < 0) perror("poll"), exit(1);
		if (!r) fprintf(stderr, "poll returned nothing\n"), exit(1);
		if (fd.revents & (POLLERR | POLLHUP | POLLNVAL) || !(fd.revents & POLLIN)) fprintf(stderr, "invalid returned events %x\n", fd.revents);
		cout << "Woke up" << endl;
	}

	return 0;
}
