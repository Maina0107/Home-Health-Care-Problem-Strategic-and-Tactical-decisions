# Function read_instance

function read_instance(filepath)
    open(filepath, "r") do f
        # Skip metadata header
        line = readline(f)
        while startswith(line, "#")
            line = readline(f)
        end

        # First data line : dimensions
        dims = parse.(Int, split(line))
        n_zones, n_centers_locations, p, n_types, n_services, n_periods = dims

        # Working hours
        # Working hours
        readline(f)  # skip comment
        hours = parse.(Int, split(readline(f)))

        # Capacity bounds
        readline(f)  # skip comment
        lower_w = zeros(Int, n_centers_locations)
        upper_w = zeros(Int, n_centers_locations)
        for i in 1:n_centers_locations
            vals = parse.(Int, split(readline(f)))
            lower_w[i] = vals[1]
            upper_w[i] = vals[2]
        end

        # Cover matrix
        readline(f)  # skip comment
        cover_matrix = zeros(Int, n_centers_locations, n_zones)
        for i in 1:n_centers_locations
            cover_matrix[i, :] = parse.(Int, split(readline(f)))
        end

        # Skill matrix
        readline(f)  # skip comment
        skill_matrix = zeros(Int, n_types, n_services)
        for k in 1:n_types
            skill_matrix[k, :] = parse.(Int, split(readline(f)))
        end

        # Demands
        readline(f)  # skip comment
        demand = zeros(Int, n_zones, n_services, n_periods)
        for j in 1:n_zones
            for l in 1:n_services
                demand[j, l, :] = parse.(Int, split(readline(f)))
            end
        end

        # Service times
        readline(f)  # skip comment
        servtime = zeros(Float64, n_services, n_periods)
        for l in 1:n_services
            servtime[l, :] = parse.(Float64, split(readline(f)))
        end

        # Opening costs
        readline(f)  # skip comment
        c_f = parse.(Int, split(readline(f)))

        # Hiring costs
        readline(f)  # skip comment
        c_hire = zeros(Int, n_centers_locations, n_types)
        for i in 1:n_centers_locations
            c_hire[i, :] = parse.(Int, split(readline(f)))
        end

        # Assignment costs
        readline(f)  # skip comment
        c_assig = zeros(Int, n_centers_locations, n_types, n_services, n_periods)
        for i in 1:n_centers_locations
            for k in 1:n_types
                for l in 1:n_services
                    c_assig[i, k, l, :] = parse.(Int, split(readline(f)))
                end
            end
        end
        
        # Hourly costs
        readline(f)  # skip comment
        c_hour = zeros(Float64, n_centers_locations, n_types, n_services, n_periods)
        for i in 1:n_centers_locations
            for k in 1:n_types
                for l in 1:n_services
                    c_hour[i, k, l, :] = parse.(Float64, split(readline(f)))
                end
            end
        end
        
        # Idle hours penalty costs
        readline(f)  # skip comment
        c_over = zeros(Int, n_centers_locations, n_types, n_periods)
        for i in 1:n_centers_locations
            for k in 1:n_types
                c_over[i, k, :] = parse.(Int, split(readline(f)))
            end
        end
        
        # Unmet demand penalty costs
        readline(f)  # skip comment
        c_unmet = zeros(Int, n_zones, n_services, n_periods)
        for j in 1:n_zones
            for l in 1:n_services
                c_unmet[j, l, :] = parse.(Int, split(readline(f)))
            end
        end

        # Scaling factor to keep costs below 1000
        scale = 1
        while maximum(c_f) / scale >= 1000
            scale *= 10
        end
        
        c_f     = c_f     ./ scale
        c_hire  = c_hire  ./ scale
        c_assig = c_assig ./ scale
        c_hour  = c_hour  ./ scale
        c_over  = c_over  ./ scale
        c_unmet = c_unmet ./ scale

        return n_zones, n_centers_locations, p, n_types, n_services, n_periods, hours,
               lower_w, upper_w, skill_matrix, cover_matrix, demand, servtime,
               c_f, c_hire, c_assig, c_hour, c_over, c_unmet
    end
end